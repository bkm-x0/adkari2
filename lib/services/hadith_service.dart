import 'package:dorar_hadith/dorar_hadith.dart';

class DorarService {
  static final DorarService _instance = DorarService._internal();
  factory DorarService() => _instance;
  DorarService._internal();

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
