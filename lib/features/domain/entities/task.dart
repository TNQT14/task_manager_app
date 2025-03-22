class Task {
  final int? id;
  final String title;
  final String description;
  final int status;
  final DateTime? dueDate;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.status = 0,
    this.dueDate,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    int? status,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
