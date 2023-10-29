class People {
  String? name;
  String? craft;
  String? thumbnailUrl;
  String? contentUrl;

  People({this.name, this.craft, this.thumbnailUrl, this.contentUrl});

  People.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    craft = json['craft'];
    thumbnailUrl = json['thumbnailUrl'];
    contentUrl = json['contentUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['craft'] = this.craft;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['contentUrl'] = this.contentUrl;
    return data;
  }
}


