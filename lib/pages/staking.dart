import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkawallet_plugin_kusama/pages/staking/actions/actions.dart';
import 'package:polkawallet_plugin_kusama/pages/staking/validators/overview.dart';
import 'package:polkawallet_plugin_kusama/utils/i18n/index.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_ui/components/pageTitleTaps.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';

import '../polkawallet_plugin_kusama.dart';

class Staking extends StatefulWidget {
  Staking(this.plugin, this.keyring);

  final PolkawalletPlugin plugin;
  final Keyring keyring;

  @override
  _StakingState createState() => _StakingState();
}

class _StakingState extends State<Staking> {
  _StakingState();

  final PageController _pageController = PageController();

  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    print("Staking===================build");
    var dic = I18n.of(context)!.getDic(i18n_full_dic_kusama, 'staking')!;
    var tabs = [dic['actions'], dic['validators']];
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 16),
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            PageTitleTabs(
              names: tabs as List<String>?,
              activeTab: _tab,
              onTab: (v) {
                if (_tab != v) {
                  setState(() {
                    _tab = v;
                  });
                  _pageController.jumpToPage(_tab);
                }
              },
            ),
            Expanded(
              child: _tab == 1
                  ? StakingOverviewPage(
                      widget.plugin as PluginKusama, widget.keyring)
                  : StakingActions(
                      widget.plugin as PluginKusama, widget.keyring),
            ),
          ],
        ),
      ),
    );
  }
}
