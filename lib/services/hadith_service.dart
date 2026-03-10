import 'package:dorar_hadith/dorar_hadith.dart';

class HadithService {
  static final HadithService _instance = HadithService._internal();
  factory HadithService() => _instance;
  HadithService._internal();

  Future<ApiResponse<List<Hadith>>> searchHadith(String query, {int page = 1}) async {
    return await DorarClient.use((client) async {
      return await client.searchHadith(
        HadithSearchParams(value: query, page: page),
      );
    });
  }

  Future<ApiResponse<List<DetailedHadith>>> searchHadithDetailed(
    String query, {
    int page = 1,
    List<HadithDegree>? degrees,
    SearchMethod? searchMethod,
  }) async {
    return await DorarClient.use((client) async {
      return await client.searchHadithDetailed(
        HadithSearchParams(
          value: query,
          page: page,
          degrees: degrees,
          searchMethod: searchMethod,
        ),
      );
    });
  }

  Future<ApiResponse<List<Sharh>>> searchSharh(String query, {int page = 1}) async {
    return await DorarClient.use((client) async {
      return await client.searchSharh(
        HadithSearchParams(value: query, page: page),
      );
    });
  }
}
