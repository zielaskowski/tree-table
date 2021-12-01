function lev(table) {
    let pathCol = table.column(".path-col").index();
    let buttonCol = table.column(".button-col").index();
    let onoffCol = table.column(".onoff-col").index();
    let oplus = "&oplus;";
    let ominus = "&CircleMinus;";
    let leaf = "|&mdash;";

    table.column(buttonCol).header().innerHTML = "";

    //coloring, pointer and indentation
    let widgetId = table.tables().nodes().to$().closest("div.datatables").attr("id");
    let d = JSON.parse($("script[data-for=" + widgetId + "][type='application/json']").text());
    let levRow = table
        .column(pathCol)
        .data()
        .toArray()
        .map(function (x) {
            return x.match(/\//g)?.length ?? 0;
        });
    let levMax = Math.max(...levRow);

    let colorBase = new KolorWheel(d.x.options.color);
    colorBase.l = 100;
    colorBase.s = 10;
    let colorTarget = colorBase.abs(-1, 50, 70, levMax + 1);
    table.rows().every(function () {
        let nds = this.nodes().to$();
        let id = this.index();
        let buttonCl = table.cell(id, buttonCol);
        //color
        nds.css({
            backgroundColor: colorTarget.get(levRow[id]).getHex(),
        });
        if (colorTarget.get(levRow[id]).isDark()) nds.css({ color: "white" });

        //indentation
        buttonCl
            .nodes()
            .to$()
            .css({
                textIndent: levRow[id] * 10 + "%",
            });
        //cursor pointer
        if (buttonCl.data() != leaf) buttonCl.nodes().to$().css({ cursor: "pointer" });
    });

    //add filtering
    //filtering is global so we need only one function
    //to know where is controling column, we create attribute
    table.nodes().to$().attr('onoffCol', onoffCol);
    $.fn.dataTable.ext.search[0] = function (set, d, i) {
        let onoffCol = set.nTable.attributes['onoffCol']?.value ?? -1;
        if (onoffCol == -1) return;
        return d[onoffCol] == 1;
    };

    //start with only top level
    table.draw();

    table.on("click", "td.button-col", function () {
        let rowId = table.row(this).index();
        let row = table.row(rowId).data();

        if (row[buttonCol].match(oplus)) {
            //show kids
            row[buttonCol] = ominus;
            let regex = new RegExp("^" + row[pathCol] + "/{0,1}[^/]+$"); //find only direct kid of the parent
            table.rows().every(function () {
                let d = this.data();
                if (regex.exec(d[pathCol])) d[onoffCol] = 1;
            });
        } else {
            if (row[buttonCol].match(ominus)) {
                //hide kids
                let regex = new RegExp("^" + row[pathCol] + "/.+$"); //find all kids of the parent
                table.rows().every(function (id) {
                    if (id < rowId) return;
                    let d = this.data();
                    if (d[buttonCol] != leaf) d[buttonCol] = oplus; //change icon
                    if (regex.exec(d[pathCol])) d[onoffCol] = 0; //hide kids rows
                });
            }
        }
        table.rows().invalidate().draw();
    });
}