<!DOCTYPE html>
<html lang="sp">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Practica JMS - 2016-0229 - 2016-0522</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">

    </head>

    <body id="page-top">

        <div class="page">
            <div class="page-main">
                <div class="header py-4">
                    <div class="container">
                        <div class="d-flex">
                            <h2>Practica JMS - ActiveMQ</h2>
                        </div>
                    </div>
                </div>
                <div class="py-4">
                    <div class="container">
                        <p class="lead">
                            Desarrollado por: <br/>
                            Manuel Espinal 2016-0229 <br/>
                            Edilio García 2016-0522
                        </p>
                    </div>
                </div>
                <div class="my-3">
                    <div class="container">
                        <div class="row row-cards">
                            <div class="col-lg-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title m-0">Temperature</h3>
                                    </div>
                                    <div id="chartContainer" style="height: 300px; width: 100%;"></div>
                                    <div class="card-footer">
                                        <h4 class="m-0">Amount of readings: <span id="temp">-1</span></h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title m-0">Humidity</h3>
                                    </div>
                                    <div id="chartContainer2" style="height: 300px; width: 100%;"></div>
                                    <div class="card-footer">
                                        <h4 class="m-0">Amount of readings: <span id="hum">-1</span></h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>
        <script src="http://canvasjs.com/assets/script/canvasjs.min.js"></script>
        <script>
            var webSocket;
            var dps = [];
            var temp = 0;
            var hum = 0;
            var dps2 = [];
            var chart = new CanvasJS.Chart("chartContainer", {
                zoomEnabled: true,
                axisX:{
                    title: "Date",
                    interval: 30,
                    intervalType: "second"
                },
                axisY: {
                    title: "Temperature",
                    includeZero: false
                },
                data: [{
                    type: "line",
                    dataPoints: dps
                }]
            });
            var chart2 = new CanvasJS.Chart("chartContainer2", {
                zoomEnabled: true,
                axisX:{
                    title: "Date",
                    interval: 30,
                    intervalType: "second"
                },
                axisY: {
                    title: "Humidity",
                    includeZero: false
                },
                data: [{
                    type: "line",
                    dataPoints: dps2
                }]
            });
            var updateInterval = 1000;
            var dataLength = 20;
            var updateChart = function (dataPoints) {
                var dp = JSON.parse(dataPoints);
                console.log(dp);
                dps.push({
                    label: dp.date,
                    y: dp.temperature
                });
                dps2.push({
                    label: dp.date,
                    y: dp.humidity
                });
                temp = parseInt(document.getElementById("temp").innerText) + 1;
                document.getElementById("temp").innerText = temp.toString();
                hum = parseInt(document.getElementById("hum").innerText) + 1;
                document.getElementById("hum").innerText = temp.toString();
                chart.render();
                chart2.render();
            };
            function socketConnect() {
                webSocket = new WebSocket("ws://" + location.hostname + ":" + location.port + "/sensor_read");
                webSocket.onmessage = function (datos) {
                    console.log("I am making a connection");
                    updateChart(datos.data);
                };
            }
            function connect() {
                if (!webSocket || webSocket.readyState === 3) {
                    socketConnect();

                }
            }
            updateChart(dataLength);
            setInterval(connect, updateInterval);
        </script>
    </body>
</html>