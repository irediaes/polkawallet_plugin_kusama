import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polkawallet_plugin_kusama/pages/governance/democracy/proposalPanel.dart';
import 'package:polkawallet_plugin_kusama/polkawallet_plugin_kusama.dart';
import 'package:polkawallet_ui/components/listTail.dart';

class Proposals extends StatefulWidget {
  Proposals(this.plugin);
  final PluginKusama plugin;

  @override
  _ProposalsState createState() => _ProposalsState();
}

class _ProposalsState extends State<Proposals> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<void> _fetchData() async {
    if (widget.plugin.sdk.api.connectedNode == null) {
      return;
    }
    await widget.plugin.service.gov.queryProposals();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _refreshKey.currentState!.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        return RefreshIndicator(
          key: _refreshKey,
          onRefresh: _fetchData,
          // ignore: unnecessary_null_comparison
          child: widget.plugin.store.gov.proposals == null ||
                  widget.plugin.store.gov.proposals.length == 0
              ? Center(child: ListTail(isEmpty: true, isLoading: false))
              : ListView.builder(
                  itemCount: widget.plugin.store.gov.proposals.length + 1,
                  itemBuilder: (_, int i) {
                    if (widget.plugin.store.gov.proposals.length == i) {
                      return Center(
                          child: ListTail(isEmpty: false, isLoading: false));
                    }
                    return ProposalPanel(
                        widget.plugin, widget.plugin.store.gov.proposals[i]);
                  }),
        );
      },
    );
  }
}
