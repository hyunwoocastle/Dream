<%@page import="java.util.*"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>

<%@page import="org.eclipse.jdt.internal.compiler.ast.PrefixExpression"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    

<%
   String ctxPath = request.getContextPath();
%>


<%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    

  <%-- header 호출 --%>
  <jsp:include page="/WEB-INF/view/header.jsp" />
  <%-- 직접 만든 CSS --%>
  <link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/product_detail.css" />
  <%-- 직접만든 javascript --%>
  <script type="text/javascript" src="<%= ctxPath%>/js/product_detail.js" >

  
  </script>







<body>


  <div class="container">
  <%-- header footer 사이 모든것 --%>
    <div class="content">

      <div class="column_bind">
        <%-- 왼쪽 오른쪽 칼럼 합친 --%>
        <div id="column_3" >
          <div id = "fixed-absolute" class="productImage">
            <%-- <div id = "fixed-absolute" class="productImage" style="width: 38vw; position: fixed ; right:52%; margin-right: 1.117%;"> --%>
            <%-- 768(태블릿 크기) 부터는 column 1,2 1줄로 나오도록 display 속성 변경 --%>
            <%-- 왼쪽  칼럼 제품이미지 상단 fixed footer 까지 내려가면 class="column is_absolute" 로 변경되도록--%>
            <%-- 왜있는지 모름 나중에 변동형 만들때 기준되나 --%>
            

            <div id = "column_1">
              <div id="productImage" class="carousel slide" data-ride="carousel" data-interval="false">
                <%-- 제품 이미지 carousel slide --%>
                <%-- Indicators --%>
                <ul class="carousel-indicators">

                <c:forEach items="${product.product_image_array}" varStatus="status">
			        <c:if test="${status.index == 0}">
			           <li data-target="#carousel_advertise" data-slide-to="${status.index}" class="active"></li>
				    </c:if>
				    <c:if test="${status.index > 0}">
			           <li data-target="#carousel_advertise" data-slide-to="${status.index}"></li>
				    </c:if>
		    	</c:forEach>
                
                </ul>
              
                <%-- The slideshow --%>
                <div class="carousel-inner">
                <c:forEach var="imgvo" items="${product.product_image_array}" varStatus="status">
                	<c:if test="${status.index == 0}">
		           		<div class="carousel-item active">
			    	</c:if>
			    	<c:if test="${status.index > 0}">
		           		<div class="carousel-item">
			    	</c:if>
                			<img src="<%= ctxPath%>/images/${imgvo}" class = "d-block w-100 pdimage" alt="제품이미지를<br>등록해주세요">
              			</div>
                </c:forEach>
                </div>
                  
                   
                   
                  <%-- Left and right controls --%>
                  <a class="carousel-control-prev" href="#productImage" data-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                  </a>
                  <a class="carousel-control-next" href="#productImage" data-slide="next">
                    <span class="carousel-control-next-icon"></span>
                  </a>
  
                </div>
              </div>

              
            </div>
            
 

        </div>
        <div id="column_2">
          <div class="main_title">
            <a href="#" class="brand"></a>
            <p class="title">${product.product_name} </p>
            <p class="sub_title"><%=request.getAttribute("pdName") %></p>
          </div>
          <div class="product_figure">
            <div class = "detail_size">
              <div class="title">
                <%-- 이 부분은 차후 모바일크기로 줄어들시<div class = "title"> 사라짐 구현시 없애기 !!!!!!!!!!!!! --%>
                <span class="title_txt">옵션</span>
              </div>  
              <%-- size div 는 의류처럼 사이즈 있는 애들한테만 노출되게 할 예정 --%>
              <div class ="size">
                
                
                <div class="dropdown">

				
				  <a id="selectOption" href="#" class="dropdown-toggle" data-toggle="dropdown">
       				선택해주세요!
                  </a>
				  <div class="dropdown-menu">
<%-- 				    <a class="dropdown-item" >Link 1</a>
				    <a class="dropdown-item" >Link 2</a>
				    <a class="dropdown-item" >Link 3</a>
				     -->
				    <%-- 사이즈(옵션이) 존재한다면 --%>
				    
				    <c:set value="${product.product_size}"  var="size" />    
					  
					<c:if test="${fn:length(size) == 0 or size == null}">
 			    		<a class="dropdown-item" >잘못된 제품입니다.</a>			
				    </c:if>	
					   
				    <c:if test="${fn:length(size) == 1}">
			    		<a class="dropdown-item" >one-size</a>			
				    </c:if>	
			    
					 
				    <c:if test="${fn:length(size) > 1}">
				    	<c:forEach items="${size}" var="option">
				    		<a class="dropdown-item" >${option}</a>	
				    	</c:forEach>	
				    </c:if>

				  </div>
				</div>
              </div>
            </div>
            
            <%-- 옵션 선택시 생기는 목록표 --%>
			<div id="optionSelected">
				
			
			</div>
            
            
            
            
            
            <div class = "detail_price">
              <div class="title">
                <span class="title_txt">가격</span>
              </div>
              <div class="price">
                <div  class="amount">
                  <span class="num"> ${product.price} </span>
                  <%-- 나중에는 데이터 받아와야해서 나눠둠 --%>
                  <span class="won">원</span>
                </div>
                <div class="fluctuation">
                  <p id="discount_price" >${product.discountPrice}원 (${product.discount_rate}%)</p>
                </div>
              </div>
            </div>
            <div class="btn_box">
              <a href="#" class="btn_buy" onclick="goPurchasePage()">
                <strong class="title">구매</strong>
                <div  class="price">
                  <span  class="amount">
                    <em  class="num">${product.discountPrice}</em>
                    <span  class="won">원</span>
                  </span>
                  <span  class="desc">즉시 구매가</span>
                </div>
              </a>
            </div>

            <a  onclick="likeCheck()" href="#" id="column2_btn_wish" class="btn btn_wish" aria-label="관심상품">
              <img style="height: 20px; width: 20px;"/>
              <%-- 즐겨찾기 아이콘 들어갈 예정 --%>
              <span class="btn_text" type="button">관심상품</span>
              <span class="wish_count_num">${product.likeCnt}</span>
              <%-- 여기 숫자는 제품 관심상품 등록된 횟수 카운트해줘야하니 나중에 제품자체에 관심등록 칼럼 추가해줘서 관리하는게 편할듯 --%>
            </a>

          </div>

          <%-- 제품정보 시작 --%>
          <div  class="product_info_wrap">
            <h3   class="detail_title info_title"> 상품 정보 </h3>
            <div   class="detail_product_wrap">
              <dl  class="detail_product">
                <%-- 여기 하위 내용들은 전부 제품테이블에 필수적으로 들어가야할 내용들 or 빼야댐 --%>
                <div  class="detail_box model_num">
                  <dt  class="product_title"> 제품번호 </dt>
                  <dd id="product_num" class="product_info"> ${product.product_num} </dd>
                </div>
                <div  class="detail_box">
                  <dt  class="product_title"> 출시일 </dt>
                  <dd  class="product_info"> ${product.register_date} </dd>
                </div>
                <div  class="detail_box">
                  <dt  class="product_title"> 컬러 </dt>
                  <dd  class="product_info"> 여기 뭘로 하지 </dd>
                </div>
                <div  class="detail_box">
                  <dt  class="product_title"> 컬러랑 합치고 </dt>
                  <dd  class="product_info"> 상세설명?</dd>
                </div>
              </dl>
            </div>
          </div>
          <%-- 제품정보 끝 --%>

          <%-- 배송방법 보여주기 시작 --%>
          <div class="delivery_way_wrap">
            <h3 class="detail_title lg"> 배송 정보 </h3>
            <div class="delivery_way">
              <div class="way_info">
                <div class="way_status_thumb">
                  <img src="https://kream-phinf.pstatic.net/MjAyMTExMjlfMTQ4/MDAxNjM4MTc4MjI5NTk3.2phJLPtRvFqViNfhZu06HzNRiUBlT4cmZR4_Ukqsyesg.ikrfWOrL7WXCVO0Rqy5kMvOn3B2YpjLUj6RuJqosPX0g.PNG/a_8b54cbca40e945f4abf1ee24bdd031f7.png" alt="3,000원" class="way_img">
                </div>
                <div class="way_desc">
                  <p class="company">
                    <span class="badge_title">일반배송 </span>
                    <span class="title">3,000원</span>
                    <%--제품 배송시 일반배송 말고 빠른배송 추가되면 그거 추가될 수 있도록 제품마다 빠른배송 가능여부 체크하는 거 만들어줘야하고 나중에 여기도 반영해줘야하는데 진짜 개빡치네--%>
                  </p>
                  <p class="sub_text">검수 후 배송 ・ 5-7일 내 도착 예정</p>
                </div>
              </div>
              <%----%>
            </div>
          </div>
          <%-- 배송방법 보여주기 끝 --%>

          <%-- 배너박스 1.멤버십 가입 페이지로 연결 or 삭제 --%>
          <div  class="banner_box" style="padding-top: 20px;">
            <img src="images/Koala.jpg" style="width:100%; height: 80px;"/> 
          </div>
          <%-- 배너박스 끝 --%>

          <%-- 구매 전 꼭 확인해주세요! 배너 시작 --%>
          <div class = "confirm_wrap" style="padding-top: 39px;">

            
            <h3 class="confirm_title">구매 전 꼭 확인해주세요! 현우 게시판에서 훔쳐올 예정</h3>
            <%-- 기능, 모양 전부 동일하게 가져다 써도 될거같음 --%>
            
          </div>  
          <%-- 구매 전 꼭 확인해주세요! 배너 끝  --%>

          <%-- 알림 가이드 시작--%>
          <div class="point_guide">
            <ul  class="guide_list">
              <li  class="guide_item">
                <div  class="thumb_area">
                  <img src="images/Koala.jpg" alt="" class="img">
                </div>
                <div class="text_area">
                  <strong  class="title">100% 정품 보증</strong>
                  <p class="desc">DREAM에서 검수한 상품이 정품이 아닐 경우, 구매가의 3배를 보상합니다.</p>
                </div>
              </li>
              <li class="guide_item">
                <div  class="thumb_area">
                  <img  src="images/Koala.jpg" alt="" class="img">
                </div>
                <div  class="text_area">
                  <strong  class="title">엄격한 다중 검수</strong>
                  <p class="desc">모든 상품은 검수센터에 도착한 후, 상품별 전문가 그룹의 체계적인 시스템을 거쳐 검수를 진행합니다.</p>
                </div>
              </li>
              <li  class="guide_item">
                <div  class="thumb_area">
                  <img  src="images/Koala.jpg" alt="" class="img">
                </div>
                <div  class="text_area">
                  <strong  class="title">정품 인증 패키지</strong>
                  <p class="desc">검수에 합격한 경우에 한하여 DREAM의 정품 인증 패키지가 포함된 상품이 배송됩니다.</p>
                </div>
              </li>
            </ul>
          </div>
          <%-- 알림 가이드 끝--%>


          <p class="meditaion_notice_product"> 드림(주)는 통신판매 중개자로서 통신판매의 당사자가 아닙니다. 본 상품은 개별판매자가 등록한 상품으로 상품, 상품정보, 거래에 관한 의무와 책임은 각 판매자에게 있습니다. 단, 거래과정에서 검수하고 보증하는 내용에 대한 책임은 드림(주)에 있습니다. </p>
          <p></p>
          

        </div>
 
      </div>

    </div>

  </div>

  <%-- 가격, 즐겨찾기 안보이면 나오는 상단 구매탭 시작--%>
  <div class="floating_price">
    <div class="inner_box">
      <div class="product_area">
        <div class="product_thumb" style="background-color: rgb(244, 244, 244);">
          <img alt="상품 이미지" src="images/Koala.jpg" class="image">
        </div>
        <div class="product_info">
          <p class="name">S${product.product_name}</p>
          <p class="translated_name">${product.product_name}</p>
        </div>
      </div>
        
      <div class="btn_area">
        <a  onclick="likeCheck()" href="#" class="btn outlinegrey btn_wish ">
          <img style="height: 20px; width: 20px;"/>
          <span class="wish_count_num">${product.likeCnt}</span>
        </a>
        <div class="division_btn_box">
          <a  href="#" class="btn_buy">
            <strong  class="title">구매</strong>
            <div  class="price">
              <span  class="amount">
                <em  class="num">${product.discountPrice}</em>
                <span  class="won">원</span>
              </span>
              <span  class="desc">즉시 구매가</span>
            </div>
          </a>
        </div>
      	</div>
      
    </div>
  <%-- 가격, 즐겨찾기 안보이면 나오는 상단 구매탭 끝--%>
  </div>
  
    <%-- banner_bottom 시작  --%>
  <%-- <div class="banner_bottom" style="margin-top: 80px;">
    <a href="#" class="banner_box">
      <div class="banner_info">
        <strong class="info_subtitle">service guide</strong>
        <p class="info_title">DREAM은 처음이지? <br>서비스 소개를 확인해보세요.</p>
        <span class="info_txt">서비스 안내</span>
      </div>
    </a>
  </div> --%>
  <%-- banner_bottom 끝  --%>
  
  
  <jsp:include page="/WEB-INF/view/footer.jsp" />
  
 <form id=temporaryCart name="temporaryCart">
    
</form>



  
   
  
  
</body>