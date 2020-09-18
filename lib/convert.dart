class Person {
  final int age;
  final String firstName;
  final String secondName;
  final List<int> listInt;
  final List<String> listStr;

  const Person({
    this.age,
    this.firstName,
    this.secondName,
    this.listInt,
    this.listStr,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Person(
      age: json["age"] as int,
      firstName: json["first_name"] as String,
      secondName: json["secondName"] as String,
      listInt: (json['listInt'] as List)?.map((e) => e as int)?.toList(),
      listStr: (json['listString'] as List)?.map((e) => e as String)?.toList(),
    );
  }
}