import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noto_todo/constants/strings.dart';
import 'package:noto_todo/domain/todo.dart';
import 'package:noto_todo/presentation/widgets/add_todo_alertdialog.dart';
import 'package:noto_todo/service/navigation_notifier.dart';
import 'package:provider/provider.dart';

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
            body: _BuildContentAnimation(),
          );
        }),
      ),
    );
  }
}

class _BuildContentAnimation extends StatefulWidget {
  const _BuildContentAnimation({
    super.key,
  });

  @override
  State<_BuildContentAnimation> createState() => _BuildContentAnimationState();
}

class _BuildContentAnimationState extends State<_BuildContentAnimation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationNotifier>(
        create: (context) => NavigationNotifier(ticker: this),
        child: Builder(
          builder: (context) {
            return Stack(
              children: [
                Container(
                  color: Colors.black,
                  height: 812.h,
                  width: 375.w,
                  child: Column(
                    children: [],
                  ),
                ),
                Positioned(
                  child: Consumer<NavigationNotifier>(
                      builder: (context, notifier, _) {
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin:0, end: notifier.scale),
                      duration: Duration(milliseconds: 500),
                      builder: (_, value, __) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..setEntry(0, 3, 200 * value)
                            ..rotateY((pi / 6) * value),
                          child: Container(
                            height: 812.h,
                            width: 375.w,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: const _BuildContent(),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                GestureDetector(
                  onHorizontalDragUpdate: (e) {
                    if(e.delta.dx > 0){
                      Provider.of<NavigationNotifier>(context, listen: false).updateDrawerState(true);
                    } else{
                      Provider.of<NavigationNotifier>(context, listen: false).updateDrawerState(false);
                    }
                  },
                )
              ],
            );
          }
        ));
  }
}

class _BuildContent extends StatelessWidget {
  const _BuildContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _BuildAppbarIcons(),
        24.verticalSpace,
        const _BuildPhrase(),
        59.verticalSpace,
        const _BuildTodoList(),
        const _BuildTodoAddingButton()
      ],
    );
  }
}

class _BuildTodoAddingButton extends StatelessWidget {
  const _BuildTodoAddingButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.0.h),
      child: SizedBox(
        height: 50.h,
        child: TextButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                TextEditingController controller = TextEditingController();
                return BuildAddTodoDialog(controller: controller);
              }),
          child: Text(
            ConstantStrings.addNewTask,
            style: TextStyle(
                color: Colors.black,
                fontSize: 25.sp,
                fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }
}

class _BuildTodoList extends StatelessWidget {
  const _BuildTodoList();

  List<Todo> getTodos(Box box) {
    return box
        .get(ConstantStrings.todosBoxKey, defaultValue: <Todo>[])!
        .cast<Todo>()
        .where((element) {
          final parsedInfo = DateTime.parse(element.dateOfCreation);
          return parsedInfo.month == DateTime.now().month &&
              parsedInfo.day == DateTime.now().day &&
              parsedInfo.year == DateTime.now().year;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<List>>(
      valueListenable: Hive.box<List>(ConstantStrings.todosBoxName)
          .listenable(keys: [ConstantStrings.todosBoxKey]),
      builder: (context, Box<List> box, _) {
        final List<Todo> todos = getTodos(box);

        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0.h),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    todos[index].isDone = !todos[index].isDone;
                    await box.put(ConstantStrings.todosBoxKey, todos);
                  },
                  child: Text(
                    todos[index].title,
                    style: todos[index].isDone
                        ? Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .fontSize)
                        : Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
            ),
            itemCount: todos.length,
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
            ConstantStrings.today,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        SizedBox(
          height: 33.h,
          child: Text(
            ConstantStrings.tomorrow,
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
      child: Padding(
        padding: EdgeInsets.only(top: 15.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/moon.svg',
            ),

          ],
        ),
      ),
    );
  }
}
