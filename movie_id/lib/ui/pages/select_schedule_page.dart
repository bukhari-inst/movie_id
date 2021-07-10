part of 'pages.dart';

class SelectSchedulePage extends StatefulWidget {
  final MovieDetail movieDetail;

  SelectSchedulePage(this.movieDetail);

  @override
  _SelectSchedulePageState createState() => _SelectSchedulePageState();
}

class _SelectSchedulePageState extends State<SelectSchedulePage> {
  List<DateTime> dates;
  DateTime selectedDate;
  // untuk ngecek bahwa jam yg dipilih hari dan jam hari ini
  int selectedTime;
  Theater selectedTheater;
  bool isValid = false; // untuk ngecek apkah sdh pilih tnggal & wktunya

  @override
  void initState() {
    super.initState();

    // datenya dibuat slama 7 hari kedepan
    dates =
        List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    selectedDate = dates[0];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // kembali ke halaman sebelumnya
        context.bloc<PageBloc>().add(GoToMovieDetailPage(widget.movieDetail));

        return;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          Container(
            color: accentColor1,
          ),
          SafeArea(
              child: Container(
            color: Colors.white,
          )),
          ListView(
            children: <Widget>[
              // note: BACK ICON
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20, left: defaultMargin),
                    padding: EdgeInsets.all(1),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .bloc<PageBloc>()
                            .add(GoToMovieDetailPage(widget.movieDetail));
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              // note: CHOOSE DATE
              Container(
                  // atas bawah: default margin, atas: 20, bawah: 16
                  margin:
                      EdgeInsets.fromLTRB(defaultMargin, 20, defaultMargin, 16),
                  child: Text(
                    "Choose Date",
                    style: blackTextFont.copyWith(fontSize: 20),
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 24),
                height: 90, // 90 dari tinggi date_card
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dates.length,
                    itemBuilder: (_, index) => Container(
                          margin: EdgeInsets.only(
                              left: (index == 0) ? defaultMargin : 0,
                              right: (index < dates.length - 1)
                                  ? 16
                                  : defaultMargin),
                          child: DateCard(dates[index],
                              isSelected: selectedDate == dates[index],
                              onTap: () {
                            setState(() {
                              selectedDate = dates[index];
                            });
                          }),
                        )),
              ),
              // note: CHOOSE TIME
              generateTimeTable(),
              // note: NEXT BUTTON
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (_, userState) => FloatingActionButton(
                    elevation: 0,
                    backgroundColor: (isValid) ? mainColor : Color(0xFFE4E4E4),
                    child: Icon(
                      Icons.arrow_forward,
                      color: isValid ? Colors.white : Color(0xFFBEBEBE),
                    ),
                    onPressed: () {
                      if (isValid) {
                        context.bloc<PageBloc>().add(GoToSelectSeatPage(Ticket(
                            widget.movieDetail,
                            selectedTheater,
                            DateTime(selectedDate.year, selectedDate.month,
                                selectedDate.day, selectedTime),
                            randomAlphaNumeric(12).toUpperCase(),
                            null,
                            (userState as UserLoaded).user.name,
                            null)));
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 41,
              ),
            ],
          )
        ]),
      ),
    );
  }

  // fungsi generateTimeTable
  Column generateTimeTable() {
    // mulai jam 10 pgi - 10 malam, jeda setiap 2 jam
    List<int> schedule = List.generate(7, (index) => 10 + index * 2);
    List<Widget> widgets = [];

    for (var theater in dummyTheater) {
      widgets.add(Container(
          margin: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 16),
          child:
              Text(theater.name, style: blackTextFont.copyWith(fontSize: 20))));

      widgets.add(Container(
        height: 50,
        margin: EdgeInsets.only(bottom: 20),
        child: ListView.builder(
            itemCount: schedule.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => Container(
                  margin: EdgeInsets.only(
                      left: (index == 0) ? defaultMargin : 0,
                      right:
                          (index < schedule.length - 1) ? 16 : defaultMargin),
                  child: SelectableBox(
                    "${schedule[index]}:00",
                    height: 50,
                    // untuk ngecek apkah sdh pilih tnggal & wktunya
                    isSelected: selectedTheater == theater &&
                        selectedTime == schedule[index],
                    // spya yg dipilih waktu stelah saat ini
                    isEnabled: schedule[index] > DateTime.now().hour ||
                        selectedDate.day != DateTime.now().day,
                    onTap: () {
                      setState(() {
                        selectedTheater = theater;
                        selectedTime = schedule[index];
                        isValid = true;
                      });
                    },
                  ),
                )),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
