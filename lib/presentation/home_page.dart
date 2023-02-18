import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noto_todo/domain/todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(
            255,
            255,
            255,
            255,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 35.sp,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              // height: 48.h
            ),
            displayMedium: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.lineThrough,
              // height: 33.h,
              color: const Color.fromARGB(
                255,
                156,
                156,
                156,
              ),
            ),
            displaySmall: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        home: Builder(builder: (context) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                children: [
                  const _BuildAppbarIcons(),
                  24.verticalSpace,
                  const _BuildPhrase(),
                  59.verticalSpace,
                  const _BuildTodoList(),
                  const _BuildTodoAddingButton()
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BuildTodoAddingButton extends StatelessWidget {
  const _BuildTodoAddingButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog(
          context: context,
          builder: (context) {
            TextEditingController _controller = TextEditingController();
            return AlertDialog(
              title: const Text(
                'Add new todo',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 15.sp,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final newTodo = Todo(
                        title: _controller.text,
                        dateOfCreation: DateTime.now().toString(),
                        isDone: false);
                    List<Todo>? listOfTodos = Hive.box<List>('Todos')
                        .get('todos_key', defaultValue: <Todo>[])!.cast<Todo>();
                    listOfTodos!.add(newTodo);
                    await Hive.box<List>('Todos')
                        .put('todos_key', listOfTodos);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Add',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 15.sp,
                        ),
                  ),
                ),
              ],
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 25.sp),
              contentPadding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 20.w,
              ),
              content: Column(
                children: [
                  TextFormField(
                    controller: _controller,
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
                      hintText: 'Enter todo title',
                    ),
                  )
                ],
              ),
            );
          }),
      child: Text(
        'Add a new task',
        style: TextStyle(
            color: Colors.black, fontSize: 25.sp, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class _BuildTodoList extends StatelessWidget {
  const _BuildTodoList();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<List>>(
      valueListenable: Hive.box<List>('Todos').listenable(keys: ['todos_key']),
      builder: (context, Box<List> box, _) {
        final List<Todo> todos = box.get('todos_key', defaultValue: <Todo>[])!.cast<Todo>();
        return SizedBox(
          height: 500.h,
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0.h),
              child: Center(
                child: Text(
                  todos[index].title,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
            itemCount: todos!.length,
          ),
        );
      },
    );
  }
}

class _BuildPhrase extends StatelessWidget {
  const _BuildPhrase();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 44.h,
          child: Text(
            'TODAY',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        SizedBox(
          height: 33.h,
          child: Text(
            'TOMORROW',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ],
    );
  }
}

class _BuildAppbarIcons extends StatelessWidget {
  const _BuildAppbarIcons();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/moon.svg',
          ),
          SvgPicture.asset(
            'assets/cofe.svg',
          ),
        ],
      ),
    );
  }
}
