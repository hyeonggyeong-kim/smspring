<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .chart-container {
        width: auto;
        height: 320px; /* 원하는 높이로 조절 */
        border: 2px solid red;
        margin-bottom: 1.5rem;
    }
</style>

<script>
    let chart1 ={
        url:'http://127.0.0.1:8088/logs/maininfo.log',
        init:function (){
            this.createChart();
        },
        createChart:function (){
            Highcharts.chart('container1', {
                chart: {
                    type: 'areaspline'
                },
                lang: {
                    locale: 'en-GB'
                },
                title: {
                    text: 'Live Data'
                },
                accessibility: {
                    announceNewData: {
                        enabled: true,
                        minAnnounceInterval: 15000,
                        announcementFormatter: function (
                            allSeries,
                            newSeries,
                            newPoint
                        ) {
                            if (newPoint) {
                                return 'New point added. Value: ' + newPoint.y;
                            }
                            return false;
                        }
                    }
                },
                plotOptions: {
                    areaspline: {
                        color: '#32CD32',
                        fillColor: {
                            linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                            stops: [
                                [0, '#32CD32'],
                                [1, '#32CD3200']
                            ]
                        },
                        threshold: null,
                        marker: {
                            lineWidth: 1,
                            lineColor: null,
                            fillColor: 'white'
                        }
                    }
                },
                data: {
                    csvURL: this.url,
                    enablePolling: true,
                    dataRefreshRate: parseInt(2, 10)
                }
            });
        }
    }
    let chart2 ={
        url:'http://127.0.0.1:8088/logs/maininfo2.log',
        init:function (){
            this.createChart();
        },
        createChart:function (){
            Highcharts.chart('container2', {
                chart: {
                    type: 'areaspline'
                },
                lang: {
                    locale: 'en-GB'
                },
                title: {
                    text: 'Live Data'
                },
                accessibility: {
                    announceNewData: {
                        enabled: true,
                        minAnnounceInterval: 15000,
                        announcementFormatter: function (
                            allSeries,
                            newSeries,
                            newPoint
                        ) {
                            if (newPoint) {
                                return 'New point added. Value: ' + newPoint.y;
                            }
                            return false;
                        }
                    }
                },
                plotOptions: {
                    areaspline: {
                        color: '#32CD32',
                        fillColor: {
                            linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                            stops: [
                                [0, '#32CD32'],
                                [1, '#32CD3200']
                            ]
                        },
                        threshold: null,
                        marker: {
                            lineWidth: 1,
                            lineColor: null,
                            fillColor: 'white'
                        }
                    }
                },
                data: {
                    csvURL: this.url,
                    enablePolling: true,
                    dataRefreshRate: parseInt(2, 10)
                }
            });
        }
    }
    let chart3 ={
        url:'http://127.0.0.1:8088/logs/maininfo3.log',
        init:function (){
            this.createChart();
        },
        createChart:function (){
            Highcharts.chart('container3', {
                chart: {
                    type: 'areaspline'
                },
                lang: {
                    locale: 'en-GB'
                },
                title: {
                    text: 'Live Data'
                },
                accessibility: {
                    announceNewData: {
                        enabled: true,
                        minAnnounceInterval: 15000,
                        announcementFormatter: function (
                            allSeries,
                            newSeries,
                            newPoint
                        ) {
                            if (newPoint) {
                                return 'New point added. Value: ' + newPoint.y;
                            }
                            return false;
                        }
                    }
                },
                plotOptions: {
                    areaspline: {
                        color: '#32CD32',
                        fillColor: {
                            linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                            stops: [
                                [0, '#32CD32'],
                                [1, '#32CD3200']
                            ]
                        },
                        threshold: null,
                        marker: {
                            lineWidth: 1,
                            lineColor: null,
                            fillColor: 'white'
                        }
                    }
                },
                data: {
                    csvURL: this.url,
                    enablePolling: true,
                    dataRefreshRate: parseInt(2, 10)
                }
            });
        }
    }
    let chart4 ={
        url:'http://127.0.0.1:8088/logs/maininfo4.log',
        init:function (){
            this.createChart();
        },
        createChart:function (){
            Highcharts.chart('container4', {
                chart: {
                    type: 'areaspline'
                },
                lang: {
                    locale: 'en-GB'
                },
                title: {
                    text: 'Live Data'
                },
                accessibility: {
                    announceNewData: {
                        enabled: true,
                        minAnnounceInterval: 15000,
                        announcementFormatter: function (
                            allSeries,
                            newSeries,
                            newPoint
                        ) {
                            if (newPoint) {
                                return 'New point added. Value: ' + newPoint.y;
                            }
                            return false;
                        }
                    }
                },
                plotOptions: {
                    areaspline: {
                        color: '#32CD32',
                        fillColor: {
                            linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                            stops: [
                                [0, '#32CD32'],
                                [1, '#32CD3200']
                            ]
                        },
                        threshold: null,
                        marker: {
                            lineWidth: 1,
                            lineColor: null,
                            fillColor: 'white'
                        }
                    }
                },
                data: {
                    csvURL: this.url,
                    enablePolling: true,
                    dataRefreshRate: parseInt(2, 10)
                }
            });
        }
    }


    $(()=>{
        chart1.init();
        chart2.init();
        chart3.init();
        chart4.init();
    })

</script>
<div class="row ">

    <!-- Earnings (Monthly) Card Example -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks
                        </div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div id="msg1" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">50%</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div id="progress1" class="progress-bar bg-info" role="progressbar"
                                         style="width: 50%" aria-valuenow="50" aria-valuemin="0"
                                         aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks
                        </div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div id="msg2" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">50%</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div id="progress2" class="progress-bar bg-info" role="progressbar"
                                         style="width: 50%" aria-valuenow="50" aria-valuemin="0"
                                         aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks
                        </div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div id="msg3" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">50%</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div id="progress3" class="progress-bar bg-info" role="progressbar"
                                         style="width: 50%" aria-valuenow="50" aria-valuemin="0"
                                         aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks
                        </div>
                        <div class="row no-gutters align-items-center">
                            <div class="col-auto">
                                <div id="msg4" class="h5 mb-0 mr-3 font-weight-bold text-gray-800">50%</div>
                            </div>
                            <div class="col">
                                <div class="progress progress-sm mr-2">
                                    <div id="progress4" class="progress-bar bg-danger" role="progressbar"
                                         style="width: 50%" aria-valuenow="50" aria-valuemin="0"
                                         aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <!-- Chart 1 -->
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Car 1</h6>
                </div>
                <div class="card-body">
                    <div id="container1" class="chart-container"></div>
                </div>
            </div>
        </div>

        <!-- Chart 2 -->
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Car 2</h6>
                </div>
                <div class="card-body">
                    <div id="container2" class="chart-container"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- 2nd Row -->
    <div class="row">
        <!-- Chart 3 -->
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Car 3</h6>
                </div>
                <div class="card-body">
                    <div id="container3" class="chart-container"></div>
                </div>
            </div>
        </div>

        <!-- Chart 4 -->
        <div class="col-xl-6 col-lg-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Car 4</h6>
                </div>
                <div class="card-body">
                    <div id="container4" class="chart-container"></div>
                </div>
            </div>
        </div>
    </div>
</div>