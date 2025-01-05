import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CBEHttpClient {
  late Dio _dio;

  CBEHttpClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://apps.cbe.com.et:100',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    // Configure certificate handling using the new approach
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client =
          HttpClient(context: SecurityContext(withTrustedRoots: false));

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        // Only accept certificates from CBE domain
        return host == 'apps.cbe.com.et';
      };

      return client;
    };

    // Add logging interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Making request to: ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Received response: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        print('Error occurred: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  Future<String> readPDF(String url) async {
    try {
      // Extract ID from URL if full URL is provided
      final Uri uri = Uri.parse(url);
      final String id = uri.queryParameters['id'] ?? url;

      // Make request
      final response = await _dio.get(
        '/',
        queryParameters: {'id': id},
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download PDF. Status: ${response.statusCode}');
      }

      // Create temporary file path
      final tempDir = Directory.systemTemp;
      final filePath = path.join(tempDir.path, '$id.pdf');

      // Save PDF to temporary location
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      // Load and extract text
      final document = PdfDocument(inputBytes: await file.readAsBytes());
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      final String text = extractor.extractText();

      // Clean up
      document.dispose();
      await file.delete();

      return text;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badCertificate) {
        throw Exception(
            'Certificate verification failed. Please check your connection or try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error reading PDF: $e');
    }
  }
}
