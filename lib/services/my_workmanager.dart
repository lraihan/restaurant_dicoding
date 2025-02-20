enum MyWorkmanager {
  oneOff("task-identifier", "task-identifier"),
  periodic(
    "ccom.example.restaurant_app_dicoding",
    "com.example.restaurant_app_dicoding",
  );

  final String uniqueName;
  final String taskName;

  const MyWorkmanager(this.uniqueName, this.taskName);
}
