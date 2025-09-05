<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    #map5{
        width:auto;
        height:400px;
        border:2px solid red;
    }
</style>
<script>
    let map5 ={
        init:function(){
            let mapContainer = document.getElementById('map5');
            let mapOption = {
                center: new kakao.maps.LatLng(39.034968356037695, 125.75303521784478),
                level: 7
            }
            let map = new kakao.maps.Map(mapContainer, mapOption);
            let mapTypeControl = new kakao.maps.MapTypeControl();
            map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
            let zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
            let positions = [
                {
                    title: '만수대대기념비',
                    latlng: new kakao.maps.LatLng(39.03247079655497, 125.753383395324)
                },
                {
                    title: '김일성 아동병원',
                    latlng: new kakao.maps.LatLng(39.042472264037585, 125.74770338030096)
                },
                {
                    title: '릉라곱등어관',
                    latlng: new kakao.maps.LatLng(39.03912613625776, 125.76409359260049)
                },
                {
                    title: '삼지연관현악단극장',
                    latlng: new kakao.maps.LatLng(39.038621399300915, 125.74575388277295)
                }
            ];
            positions.forEach(p => {
                let marker = new kakao.maps.Marker({
                    position: p.latlng,
                    title: p.title
                });
                marker.setMap(map);

                let iwContent = new kakao.maps.InfoWindow({
                    content: '<div style="padding:6px 8px;white-space:nowrap;">'+ p.title +'</div>'
                });
                kakao.maps.event.addListener(marker, 'click', function(){
                    if (openInfoWin) openInfoWin.close();
                    iw.open(map, marker);
                    openInfoWin = iw;
                });

                bounds.extend(p.latlng);
            });
        }
    }
    $(function(){
        map5.init()
    });
</script>
<div class="col-sm-10">
    <h2>Map5</h2>
    <div id="map5"></div>
</div>