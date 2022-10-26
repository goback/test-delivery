import 'package:dio/dio.dart';
import 'package:prac/common/const/data.dart';

class CustomInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    try {
      if (isStatus401 && !isPathRefresh) {
        final Dio dio = Dio();

        final refreshResponse = await dio.post('http://$ip/auth/token',
            options: Options(headers: {'authorization': 'Bearer $refreshToken'}));

        final accessToken = refreshResponse.data['accessToken'];

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        RequestOptions requestOptions = err.requestOptions;

        requestOptions.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      }
    } on DioError catch(e) {
      return handler.reject(e);
    }
  }
}
