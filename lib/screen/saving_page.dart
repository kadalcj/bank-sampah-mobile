import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SavingPage extends StatefulWidget {
  @override
  _SavingPageState createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrCodeText = '';
  QRViewController qrViewController;

  // Context
  BuildContext _ctx;

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _initPage(context),
      ),
    );
  }

  Widget _initPage(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _scannerContainer(context),
          _actionContainer(),
        ],
      ),
    );
  }

  Widget _scannerContainer(BuildContext context) {
    return Expanded(
      child: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrViewController) {
    this.qrViewController = qrViewController;
    qrViewController.scannedDataStream.listen(
      (scanData) {
        setState(
          () {
            qrCodeText = scanData;

            qrViewController.pauseCamera();

            Navigator.pushNamed(_ctx, '/savingConfirm', arguments: qrCodeText)
                .then(
              (value) {
                // if (value == null) value = false;

                if (value) {
                //   Scaffold.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text('Terjadi Kesalahan'),
                //     ),
                //   );
                
                  qrViewController.resumeCamera();
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _actionContainer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          Text(
            'Petunjuk',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.green,
                  ),
                  child: SvgPicture.asset(
                    'assets/qr_code_icon.svg',
                    width: 100.0,
                    height: 100.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'Scan Barcode Yang Terdapat Pada Mesin Yang Tersedia!',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    qrViewController?.dispose();

    super.dispose();
  }
}
