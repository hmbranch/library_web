<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>도서관 자리예약 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <c:choose>
        <%-- 로그인이 안된 경우 --%>
        <c:when test="${empty loginUser}">
            <div class="login-container">
                <div class="login-box">
                    <div class="logo">📚</div>
                    <h1>도서관 관리 시스템</h1>
                    <p class="subtitle">편리하고 빠른 좌석 예약 서비스</p>
                    
                    <div class="login-menu">
                        <a href="/library/login" class="btn btn-primary">
                            <span class="btn-icon">🔐</span>
                            로그인
                        </a>
                        <a href="/library/register" class="btn btn-secondary">
                            <span class="btn-icon">👤</span>
                            회원가입
                        </a>
                    </div>
                    
                    <div class="info-section">
                        <h3>📋 이용 안내</h3>
                        <ul>
                            <li>회원가입 후 좌석 예약이 가능합니다</li>
                            <li>1인 1좌석까지 예약 가능합니다</li>
                            <li>예약 시간은 최대 4시간입니다</li>
                        </ul>
                    </div>
                </div>
            </div>
        </c:when>
        
        <%-- 로그인된 경우 --%>
        <c:otherwise>
            <div class="header">
                <h1>📚 도서관 관리 시스템</h1>
                <div class="user-info">
                    <span>안녕하세요, <strong>${loginUser.name}</strong>님!</span>
                    <a href="/library/logout" class="logout-btn">로그아웃</a>
                </div>
            </div>
            
            <div class="container">
                <div class="welcome-section">
                    <div class="logo">📚</div>
                    <h1>도서관 자리예약</h1>
                    <p class="subtitle">편리하고 빠른 좌석 예약 서비스</p>
                </div>

                <div class="status-bar">
                    <div class="status-info">
                        <span class="status-label">현재 이용 가능한 좌석</span>
                        <span class="status-value available">${stats.availableSeats}석</span>
                    </div>
                    <div class="status-info">
                        <span class="status-label">사용 중인 좌석</span>
                        <span class="status-value occupied">${stats.occupiedSeats}석</span>
                    </div>
                    <div class="status-info">
                        <span class="status-label">전체 좌석</span>
                        <span class="status-value total">${stats.totalSeats}석</span>
                    </div>
                </div>

                <div class="menu-grid">
                    <a href="/seats" class="menu-item">
                        <span class="menu-item-icon">🪑</span>
                        <span class="menu-item-text">좌석 현황</span>
                    </a>
                    <a href="/seats/reservation" class="menu-item">
                        <span class="menu-item-icon">📝</span>
                        <span class="menu-item-text">예약하기</span>
                    </a>
                    <a href="/mypage" class="menu-item">
                        <span class="menu-item-icon">👤</span>
                        <span class="menu-item-text">내 예약</span>
                    </a>
                    <a href="javascript:alert('준비중입니다')" class="menu-item">
                        <span class="menu-item-icon">📖</span>
                        <span class="menu-item-text">도서 목록</span>
                    </a>
                </div>

                <div class="footer">
                    <p>📞 문의: 032-123-4567 | 🕒 운영시간: 09:00 - 22:00</p>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>