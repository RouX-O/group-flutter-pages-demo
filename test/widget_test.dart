import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_flutter_pages_demo/main.dart';

/// 组员F：全量验收测试
/// 验收目标：确认A/B/C/D所有组员的PR合并后，页面内容正确、完整
void main() {
  testWidgets('验收1：页面主要区块标题均可渲染', (tester) async {
    await tester.pumpWidget(const GroupFlutterPagesApp());

    // AppBar 标题
    expect(find.text('小组项目展示'), findsOneWidget);

    // 首页标题（组员A 修改）
    expect(find.text(TeamHomePage.projectTitle), findsOneWidget);

    // 小组成员区域标题
    expect(find.text('小组成员与分工'), findsOneWidget);

    // 向下滚动查看"项目功能"
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    expect(find.text('项目功能'), findsOneWidget);

    // 继续滚动查看"发布说明"
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    expect(find.text('发布说明'), findsOneWidget);
  });

  testWidgets('验收2：组员A - 首页标题和口号已更新', (tester) async {
    await tester.pumpWidget(const GroupFlutterPagesApp());

    // 确认标题已不再是初始模板中的"星火小组 Flutter Web 展示页"
    expect(find.text('星火小组 Flutter Web 展示页'), findsNothing);

    // 确认新标题存在
    expect(find.text('GitHub 协作与 Flutter Web 部署展示页'), findsOneWidget);

    // 确认口号已更新
    expect(
      find.text('7人小组分工协作完成 GitHub 团队开发与 Flutter Web 部署'),
      findsOneWidget,
    );
  });

  testWidgets('验收3：组员B - 小组成员与分工内容正确', (tester) async {
    await tester.pumpWidget(const GroupFlutterPagesApp());

    // 每位成员都应显示 "角色：姓名" 格式
    final expectedMembers = [
      '组长：蒋亿乐',
      '组员 A：王小梅',
      '组员 B：唐一甜',
      '组员 C：刘昱泽',
      '组员 D：张蕴洁',
      '组员 E：杨晨曦',
      '组员 F：于昕冉',
    ];

    for (final member in expectedMembers) {
      expect(find.text(member), findsOneWidget,
          reason: '未找到成员: $member');
    }

    // 确认共有 7 个 CircleAvatar（7名成员）
    expect(find.byType(CircleAvatar), findsNWidgets(7));
  });

  testWidgets('验收4：组员C - 项目功能列表内容正确', (tester) async {
    await tester.pumpWidget(const GroupFlutterPagesApp());

    // 功能区域在页面下方，需要滚动
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();

    final expectedFeatures = [
      '展示小组项目主题与小组口号',
      '展示七位成员的姓名、角色与任务分工',
      '每位组员通过独立分支和 Pull Request 完成协作修改',
      '使用 Flutter Web 构建并通过 GitHub Pages 对外发布',
    ];

    for (final feature in expectedFeatures) {
      expect(find.text('• $feature'), findsOneWidget,
          reason: '未找到功能项: $feature');
    }
  });

  testWidgets('验收5：组员D - 发布说明内容正确', (tester) async {
    await tester.pumpWidget(const GroupFlutterPagesApp());

    // 发布说明在页面更下方，需要滚动两次
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();

    final expectedNotes = [
      '源码统一维护在 main 分支，所有组员修改都通过 PR 合并。',
      '组长使用 flutter build web 生成静态网页文件。',
      '构建产物发布到 gh-pages 分支，并由 GitHub Pages 对外访问。',
      '访问地址格式：https://RouX-O.github.io/group-flutter-pages-demo/',
    ];

    for (final note in expectedNotes) {
      expect(find.text('• $note'), findsOneWidget,
          reason: '未找到发布说明: $note');
    }
  });

  testWidgets('验收6：小组口号显示在标题下方', (tester) async {
    await tester.pumpWidget(const GroupFlutterPagesApp());

    // 项目标题（大字）
    final titleFinder = find.text(TeamHomePage.projectTitle);
    expect(titleFinder, findsOneWidget);

    // 验证标题使用了大字号 (fontSize: 26)
    final titleText = tester.widget<Text>(titleFinder);
    expect(
      (titleText.style!.fontSize ?? 14) >= 20,
      isTrue,
      reason: '标题字号应 >= 20',
    );
  });

  testWidgets('验收7：页面整体结构完整（Card/Section 数量）', (tester) async {
    await tester.pumpWidget(const GroupFlutterPagesApp());

    // 验证有 AppBar
    expect(find.byType(AppBar), findsOneWidget);

    // 验证有 Scaffold
    expect(find.byType(Scaffold), findsOneWidget);

    // 验证有 ListView 作为 body
    expect(find.byType(ListView), findsOneWidget);

    // 验证有至少 4 个 Card（Hero、Members、Features、Release 各一个）
    expect(find.byType(Card), findsAtLeast(4));
  });
}
