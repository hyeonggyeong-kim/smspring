<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    #map1{
        width:auto;
        height:400px;
        border:2px solid red;
    }
</style>
<script>
    let map1 = {
        // 마커가 움직일 좌표들을 배열로 저장할 거야!
        // Kakao Maps의 LatLng 객체 배열로 미리 만들어두면 편리해!
        markerPositions: [],
        currentIndex: 0,       // 현재 마커가 위치한 좌표의 인덱스
        marker: null,          // Kakao Maps 마커 객체
        map: null,             // Kakao Maps 지도 객체
        animationInterval: null, // setInterval의 ID를 저장해서 나중에 멈출 수도 있게!

        init: function(){
            let mapContainer = document.getElementById('map1');
            let mapOption = {
                center: new kakao.maps.LatLng(36.799131, 127.075013), // 지도의 초기 중심 좌표 (네가 정한 위치)
                level: 7 // 지도의 확대 레벨
            };
            this.map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성

            // 지도 컨트롤 추가 (네비게이션, 확대/축소)
            let mapTypeControl = new kakao.maps.MapTypeControl();
            this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
            let zoomControl = new kakao.maps.ZoomControl();
            this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            // 마커가 이동할 좌표들 설정!
            this.markerPositions = [
                new kakao.maps.LatLng(36.802937, 127.070030), // 첫 번째 위치
                new kakao.maps.LatLng(36.806432, 127.084815), // 두 번째 위치
                new kakao.maps.LatLng(36.798511, 127.091764), // 세 번째 위치
                new kakao.maps.LatLng(36.791852, 127.081781)  // 네 번째 위치
            ];

            // 마커를 처음 위치에 생성해!
            this.marker = new kakao.maps.Marker({
                position: this.markerPositions[0], // 마커는 첫 번째 좌표에서 시작해!
                map: this.map
            });

            // Infowindow (이 부분은 기존 코드와 동일하게 두었어!)
            let iwContent = 'Info Window';
            let infowindow = new kakao.maps.InfoWindow({
                content : iwContent
            });

            // Event (마커에 마우스 오버/아웃, 클릭 이벤트)
            // 여기서 this는 이벤트 리스너 내부에서는 map1 객체가 아니므로, 명시적으로 map1.map, map1.marker 사용해야 해!
            kakao.maps.event.addListener(this.marker, 'mouseover', function (){
                infowindow.open(map1.map, map1.marker);
            });
            kakao.maps.event.addListener(this.marker, 'mouseout', function (){
                infowindow.close();
            });
            kakao.maps.event.addListener(this.marker, 'click', function (){
                location.href='<c:url value="/cust/get"/>';
            });

            // 2초마다 마커를 다음 위치로 이동시키는 함수를 호출해!
            this.currentIndex = 0; // 시작 인덱스를 0으로 초기화
            this.animationInterval = setInterval(() => this.moveNextMarker(), 2000); // 2000ms = 2초
        },

        // 마커를 다음 좌표로 이동시키는 함수
        moveNextMarker: function() {
            // 다음 인덱스를 계산해 (배열의 끝에 다다르면 다시 처음으로 돌아가!)
            this.currentIndex = (this.currentIndex + 1) % this.markerPositions.length;
            let nextPos = this.markerPositions[this.currentIndex];

            // 마커의 위치를 업데이트해!
            this.marker.setPosition(nextPos);


            this.map.setCenter(nextPos);
        },
    };

    $(function(){
        map1.init(); // 페이지 로드되면 지도 초기화 및 애니메이션 시작!
    });
</script>
<div class="col-sm-10">
    <h2>Map6</h2>
    <div id="map1"></div>
</div>