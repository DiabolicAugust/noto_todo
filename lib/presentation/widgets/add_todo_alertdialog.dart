import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:noto_todo/constants/strings.dart';
import 'package:noto_todo/domain/todo.dart';

class BuildAddTodoDialog extends StatelessWidget {
  final TextEditingController controller;

  const BuildAddTodoDialog({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        ConstantStrings.addNewTask,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            ConstantStrings.cancel,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: 15.sp,
                ),
          ),
        ),
        TextButton(
          onPressed: () async {
            final newTodo = Todo(
                title: controller.text,
                dateOfCreation: DateTime.now().toString(),
                isDone: false);
            List<Todo>? listOfTodos =
                Hive.box<List>(ConstantStrings.todosBoxName).get(
                    ConstantStrings.todosBoxKey,
                    defaultValue: <Todo>[])!.cast<Todo>();
            listOfTodos.add(newTodo);
            await Hive.box<List>(ConstantStrings.todosBoxName)
                .put(ConstantStrings.todosBoxKey, listOfTodos);
            Navigator.pop(context);
          },
          child: Text(
            ConstantStrings.add,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 15.sp,
                ),
          ),
        ),
      ],
      titleTextStyle:
          Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 25.sp),
      contentPadding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 20.w,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value!.isEmpty) const Text(ConstantStrings.cantBeEmpty);
              if (value.length < 3) const Text(ConstantStrings.tooShort);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    8.r,
                  ),
                ),
                borderSide: BorderSide(
                  width: 5.w,
                ),
              ),
              hintText: ConstantStrings.enterTodoTitle,
            ),
          )
        ],
      ),
    );
  }
}
