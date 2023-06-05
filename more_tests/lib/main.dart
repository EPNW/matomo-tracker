import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'random_alpha_numeric.dart';

typedef TrackCall = void Function(
  Campaign? campaign,
  String? pvId,
  bool newVisit,
);

TrackCall callFor(TrackType e) {
  return (Campaign? campaign, String? pvId, bool newVisit) {
    switch (e) {
      case TrackType.cart:
        MatomoTracker.instance.trackCartUpdate(
            campaign: campaign,
            pvId: pvId,
            newVisit: newVisit,
            path: '/cart',
            trackingOrderItems: const [
              TrackingOrderItem(
                sku: '12',
                name: 'TestCartItem',
              ),
            ]);
        break;
      case TrackType.contentImpression:
        MatomoTracker.instance.trackContentImpression(
          campaign: campaign,
          pvId: pvId,
          newVisit: newVisit,
          path: '/content',
          content: Content(
            name: 'TestContent',
          ),
        );
        break;
      case TrackType.contentInteraction:
        MatomoTracker.instance.trackContentInteraction(
            campaign: campaign,
            pvId: pvId,
            path: '/content',
            content: Content(
              name: 'TestContent',
            ),
            interaction: 'Tap');
        break;
      case TrackType.dimensions:
        MatomoTracker.instance.trackDimensions(
          campaign: campaign,
          pvId: pvId,
          newVisit: newVisit,
          path: '/dimensions',
          dimensions: {
            'dimension1': 'Hello World!',
          },
        );
        break;
      case TrackType.event:
        MatomoTracker.instance.trackEvent(
            campaign: campaign,
            pvId: pvId,
            newVisit: newVisit,
            path: '/event',
            eventInfo: EventInfo(
              category: 'EventCategory',
              action: 'EventAction',
            ));
        break;
      case TrackType.goal:
        MatomoTracker.instance.trackGoal(
          campaign: campaign,
          pvId: pvId,
          newVisit: newVisit,
          path: '/goal',
          id: 123,
        );
        break;
      case TrackType.order:
        MatomoTracker.instance.trackOrder(
          campaign: campaign,
          pvId: pvId,
          newVisit: newVisit,
          path: '/order',
          trackingOrderItems: const [
            TrackingOrderItem(
              sku: '11',
              name: 'TestOrderItem',
            ),
          ],
          id: '12',
          revenue: 13.50,
        );
        break;
      case TrackType.outlink:
        MatomoTracker.instance.trackOutlink(
            campaign: campaign,
            pvId: pvId,
            newVisit: newVisit,
            path: '/outlink',
            link: 'https://epnw.eu');
        break;
      case TrackType.pageView:
        MatomoTracker.instance.trackScreenWithName(
          campaign: campaign,
          pvId: pvId,
          newVisit: newVisit,
          path: '/pageView',
          actionName: 'ActionName',
        );
        break;
      case TrackType.search:
        MatomoTracker.instance.trackSearch(
          campaign: campaign,
          pvId: pvId,
          newVisit: newVisit,
          path: '/search',
          searchKeyword: 'SearchCeyword',
          searchCategory: 'SearchCategory',
          searchCount: 3,
        );
        break;
    }
  };
}

const _matomoEndpoint = 'http://localhost:8765/matomo.php';
const _sideId = 1;
const _testUserId = 'Panda';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MatomoTracker.instance.initialize(
    siteId: _sideId,
    url: _matomoEndpoint,
    verbosityLevel: Level.all,
    newVisit: false,
    attachLastScreenInfo: false,
    pingInterval: null,
  );
  MatomoTracker.instance.setVisitorUserId(_testUserId);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

enum TrackType {
  cart,
  contentImpression,
  contentInteraction,
  dimensions,
  event,
  goal,
  order,
  outlink,
  pageView,
  search;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static String _newPvId() => randomAlphaNumeric(6);

  final List<String> _history = [];
  bool _sending = false;
  bool _newVisit = true;
  bool _nameValid = false;
  bool _addPvId = true;
  bool _withCampaing = false;
  String _pvId = _newPvId();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_nameValidityCheck);
  }

  void _nameValidityCheck() {
    bool nowValid = _nameController.text.trim().isNotEmpty;
    if (_nameValid != nowValid) {
      setState(() {
        _nameValid = nowValid;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.removeListener(_nameValidityCheck);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              Opacity(
                opacity: _sending ? 0.5 : 1.0,
                child: _controlWidget(context),
              ),
              if (_sending)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
          Expanded(
            child: _historyWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _controlWidget(BuildContext context) {
    bool canSend = !_sending && _nameValid;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Name:    '),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              width: 300,
              child: TextField(
                controller: _nameController,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Keyword:'),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              width: 300,
              child: TextField(
                controller: _keywordController,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('New Visit:'),
            Switch(
              value: _newVisit,
              onChanged: _sending
                  ? null
                  : (bool newValue) => setState(() {
                        _newVisit = newValue;
                      }),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            const Text('With Campaign:'),
            Switch(
              value: _withCampaing,
              onChanged: _sending
                  ? null
                  : (bool newValue) => setState(() {
                        _withCampaing = newValue;
                      }),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current PvId: $_pvId'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            ElevatedButton(
              onPressed: !_sending
                  ? () => setState(() {
                        _pvId = _newPvId();
                      })
                  : null,
              child: const Text('New'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            const Text('Add pvId?'),
            Switch(
              value: _addPvId,
              onChanged: _sending
                  ? null
                  : (bool newValue) => setState(() {
                        _addPvId = newValue;
                      }),
            ),
          ],
        ),
        _grid(context, canSend)
      ],
    );
  }

  Widget _grid(BuildContext context, bool canSend) => Wrap(
        children: TrackType.values
            .map(
              (TrackType e) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 5.0,
                ),
                child: ElevatedButton(
                  onPressed: canSend
                      ? () => _callback(
                            e,
                            callFor(e),
                          )
                      : null,
                  child: Text(e.name),
                ),
              ),
            )
            .toList(),
      );

  Future<void> _callback(TrackType type, TrackCall trackCall) async {
    setState(() {
      _sending = true;
    });
    Campaign? campaign = _withCampaing
        ? Campaign(
            name: _nameController.text,
            keyword: _keywordController.text.trim().isEmpty
                ? null
                : _keywordController.text,
          )
        : null;
    String? pvId = (_addPvId || type == TrackType.pageView) ? _pvId : null;
    Map<String, String> map = {
      'type': type.toString(),
      'newVisit': _newVisit.toString(),
      if (pvId != null) 'pvId': pvId,
      ...(campaign?.toMap() ?? {})
    };
    trackCall(campaign, pvId, _newVisit);
    // ignore: invalid_use_of_visible_for_testing_member
    String raw = json.encode(MatomoTracker.instance.queue.last);
    await MatomoTracker.instance.dispatchActions();
    setState(() {
      _sending = false;
      _history.add('${json.encode(map)} -> $raw');
    });
  }

  Widget _historyWidget(BuildContext context) {
    List<Widget> history = [];
    for (int i = 0; i < _history.length; i++) {
      Widget w = Container(
        color: _colors[i % _colors.length],
        child: Text(_history[i]),
      );
      history.insert(0, w);
    }
    return ListView(
      children: history,
    );
  }
}

const _colors = [
  Colors.redAccent,
  Colors.blueAccent,
  Colors.yellowAccent,
  Colors.purpleAccent,
  Colors.pinkAccent
];
