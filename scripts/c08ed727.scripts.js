(function(){angular.module("idfBudgetApp",["ngResource","ngSanitize","ngRoute"]).config(["$routeProvider",function(a){return a.when("/",{templateUrl:"views/main.html",controller:"MainCtrl",reloadOnSearch:!1}).otherwise({redirectTo:"/"})}])}).call(this),function(){angular.module("idfBudgetApp").directive("landscape",function(){return{restrict:"A",scope:{foreground:"@",background:"@",wrapper:"@",listen:"@",scrollDuration:"@"},link:function(a,b,c){var d,e,f,g;return f=function(a){var c;return c=angular.isNumber(a)?".zone-"+a:a,b.scrollTo(c,{duration:d.scrollDuration,offset:-1*(e.width()/2-$(c).outerWidth()/2)})},e=b.parents(".main"),d={bg:angular.element(a.background||".background"),fg:angular.element(a.foreground||".foreground"),wp:angular.element(a.wrapper),bgVelocity:.3,fgVelocity:-.8,scrollDuration:a.scrollDuration||600},d.wp&&(g=$("<div />").css({width:d.wp.width(),height:d.wp.height(),overflow:"hidden",position:"relative"}),b.wrapInner(g)),b.on("scroll",function(){var a;return a=b.scrollLeft(),d.bg.css("left",a*d.bgVelocity),d.fg.css("left",a*d.fgVelocity)}),null!=a.listen?a.$parent.$watch(a.listen,f):void 0}}})}.call(this),function(){angular.module("idfBudgetApp").directive("bound",function(){return{restrict:"A",link:function(a,b,c){var d,e,f,g,h,i,j,k,l,m,n,o;return h=b.parents(c.parent||window),n=h.outerWidth(),f=h.outerHeight(),k=c.step,g=1*(c.offset||0),l=c.bound.split(";"),2===l.length?(l={left:1*l[0],top:1*l[1]},j=d3.svg.line().x(function(a){return a.x}).y(function(a){return a.y}).interpolate("linear"),d=function(){return i.attr("d",j(e()))},e=function(){var a;return a=b.offset(),a={left:a.left-h.offset().left+g,top:a.top-h.offset().top+b.outerHeight()/2},k||(k=.5*(a.left-l.left)),a.left<l.left&&k>0&&(k*=-1),[{x:a.left,y:a.top},{x:a.left-k,y:a.top},{x:a.left-k,y:l.top},{x:l.left,y:l.top}]},o=$("<div />"),o.addClass("js-bound-draw").css({top:0,left:0,right:0,bottom:0,position:"absolute"}),h.append(o),m=d3.select(o[0]).append("svg").attr("width",n).attr("height",f),i=m.append("path").attr("stroke","#586063").attr("stroke-width",1).attr("fill","none"),b.hover(function(){return o.removeClass("hidden")},function(){return o.addClass("hidden")})):void 0}}})}.call(this),function(){angular.module("idfBudgetApp").controller("MainCtrl",["$scope","$location","$http","$rootElement",function(a,b,c,d){var e,f,g,h,i,j,k,l;return e=8,g=".home-center",f=d.find(".scrollable"),i=function(a){var b,c;return c=CSV.parse(a),c.length?(b=c.shift(),c=_.map(c,function(a){return _.object(b,a)})):void 0},j=function(b,c,e,f){return null==b&&(b=d),null==c&&(c="fade"),null==e&&(e=700),null==f&&(f=function(){}),b.addClass(c),setTimeout(function(){return b.removeClass(c),f(),a.$apply()},700)},l=function(){return j(d.find(".js-fade"),"do-fade",700,function(){return null!=a.details?a.detail=a.getDetail(a.activeZone):void 0})},k=function(){var c;return c="home"===a.screen,a.screen=b.search().screen||"home","home"===a.screen&&a.zone(g),"detail"===a.screen&&c&&a.zone(e),"global"===a.screen?f.scrollTo({top:250,left:0},600):f.scrollTo(0,600)},h=function(){return _.findIndex(a.details,{id:a.activeZone})},a.to=function(a){return null==a&&(a="home"),b.search("screen",a)},a.zone=function(b){return null==b&&(b=!1),b&&(a.activeZone=b),a.activeZone},a.next=function(){return a.activeZone=a.details[h()+1].id},a.prev=function(){return a.activeZone=a.details[h()-1].id},a.hasNext=function(){return null!=a.details[h()+1]},a.hasPrev=function(){return null!=a.details[h()-1]},a.getDetail=function(b){return _.find(a.details,{id:b})},a.details=[],a.activeZone=g,a.screen="home",k(),c.get("./data/details.csv").success(function(b){return a.details=_.sortBy(i(b),function(a){return Number(a.id)}),l()}),c.get("./data/budget.csv").success(function(b){return a.budget=i(b)}),a.$watch("activeZone",l),a.$on("$routeUpdate",k)}])}.call(this),function(){angular.module("idfBudgetApp").directive("homothety",["$window",function(a){return{restrict:"A",link:function(b,c,d){var e,f,g,h;return g=function(){var a;return a=Math.min(1,h.width()/f),e.css("min-height",c.height()*a),c.css({transform:"scale("+a+")","transform-origin":"center top"}),a},f=c.outerWidth(),h=angular.element(a),e=angular.element("body"),h.on("resize",g),g()}}}])}.call(this);