class Tax {
  int id;
  String region;
  String type;
  double rate;

  Tax({
    required this.id,
    required this.region,
    required this.type,
    required this.rate,
  });
}

final List<String> allRegions = ['US', 'EU', 'Asia'];
final List<String> allTaxTypes = ['VAT', 'GST', 'Income Tax'];
