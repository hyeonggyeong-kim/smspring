<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #map { width:auto; height:400px; border:2px solid red; }
  .poi-wrap { padding:6px 8px; font-size:12px; line-height:1.4; max-width:260px; }
  .poi-img  { width:100%; max-width:90px; height:auto; border-radius:6px; margin:4px 0; }
</style>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bba38ddc4880e6efa7f4ce915c9f863f&autoload=false"></script>

<script>
  const IMG_BASE = '<c:url value="/img/"/>';

  let mapApp = {
    map: null,
    bike: null,
    poiMarkers: [],
    circle: null,
    currentInfoWindow: null,
    me: { lat: 36.800209, lng: 127.074968 },

    init() {
      if (!window.kakao || !kakao.maps) kakao.maps.load(() => this._init());
      else this._init();
    },
    _init() {
      this.makeMap();
      this.tryGeolocation(() => {
        this.drawRadius(3);
        this.loadNearby();
        this.ensureBike();
        setInterval(() => this.stepBike(), 2000);
        setInterval(() => this.loadNearby(), 10000);
      });
    },

    tryGeolocation(done) {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
                pos => {
                  this.me.lat = pos.coords.latitude;
                  this.me.lng = pos.coords.longitude;
                  this.map.setCenter(new kakao.maps.LatLng(this.me.lat, this.me.lng));
                  done && done();
                },
                _err => { done && done(); },
                { enableHighAccuracy:true, timeout:3000 }
        );
      } else { done && done(); }
    },

    makeMap() {
      const opt = { center: new kakao.maps.LatLng(this.me.lat, this.me.lng), level: 5 };
      this.map = new kakao.maps.Map(document.getElementById('map'), opt);
      this.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
      this.map.addControl(new kakao.maps.ZoomControl(),     kakao.maps.ControlPosition.RIGHT);

      kakao.maps.event.addListener(this.map, 'click', () => {
        if (this.currentInfoWindow) { this.currentInfoWindow.close(); this.currentInfoWindow = null; }
      });
    },

    drawRadius(km) {
      if (this.circle) this.circle.setMap(null);
      this.circle = new kakao.maps.Circle({
        center: new kakao.maps.LatLng(this.me.lat, this.me.lng),
        radius: km * 1000,
        strokeWeight: 3, strokeColor: '#4A89F3', strokeOpacity: 0.8,
        fillColor: '#4A89F3', fillOpacity: 0.15
      });
      this.circle.setMap(this.map);
    },

    ensureBike() {
      if (this.bike) return;
      const img = new kakao.maps.MarkerImage(IMG_BASE + 'bike.jpg', new kakao.maps.Size(30,30));
      this.bike = new kakao.maps.Marker({
        position: new kakao.maps.LatLng(this.me.lat, this.me.lng), image: img
      });
      this.bike.setMap(this.map);
    },

    stepBike() {
      if (!this.bike) this.ensureBike();
      const pos = this.bike.getPosition();
      $.getJSON('/map/api/bike/step', { lat: pos.getLat(), lng: pos.getLng() })
              .done(p => this.bike.setPosition(new kakao.maps.LatLng(p.lat, p.lng)))
              .fail(xhr => console.error('bike/step error', xhr.status, xhr.responseText));
    },

    _esc(s){ return String(s || '').replace(/[&<>"']/g, m => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m])); },

    loadNearby() {
      $.getJSON('/map/api/nearby', { lat: this.me.lat, lng: this.me.lng, radiusKm: 3, limit: 30 })
              .done(list => {
                this.poiMarkers.forEach(m => m.setMap(null));
                this.poiMarkers = [];
                if (!list || list.length === 0) return;

                list.forEach(item => {
                  const title = item.title || '가게';
                  const addr  = item.loc   || '';
                  const info  = item.info  || '';
                  const dist  = (typeof item.distance === 'number')
                          ? (item.distance.toFixed ? item.distance.toFixed(2) : item.distance) + ' km' : '';
                  const imgUrl = item.img ? (IMG_BASE + encodeURIComponent(item.img)) : null;

                  const mk = new kakao.maps.Marker({
                    position: new kakao.maps.LatLng(item.lat, item.lng),
                    clickable: true,
                    title: title
                  });
                  mk.setMap(this.map);
                  this.poiMarkers.push(mk);

                  let html =
                          '<div class="poi-wrap">' +
                          '<b>' + this._esc(title) + '</b><br/>' +
                          (addr ? ('주소 : ' + this._esc(addr) + '<br/>') : '') +
                          (info ? ('상세정보 : ' + this._esc(info) + '<br/>') : '') +
                          (dist ? ('거리 : ' + dist + '<br/>') : '');
                  if (imgUrl) html += '<img class="poi-img" src="' + imgUrl + '" alt="' + this._esc(title) + '">';
                  html += '</div>';

                  const iw = new kakao.maps.InfoWindow({ content: html });

                  kakao.maps.event.addListener(mk, 'click', () => {
                    if (this.currentInfoWindow) { this.currentInfoWindow.close(); }
                    iw.open(this.map, mk);
                    this.currentInfoWindow = iw;
                  });
                });
              })
              .fail(xhr => {
                console.error('nearby error', xhr.status, xhr.responseText);
                alert('근처 가게 조회 실패: ' + xhr.status);
              });
    }
  };

  $(function(){ mapApp.init(); });
</script>

<div class="col-sm-10">
  <h2>Map</h2>
  <div id="map"></div>
</div>
