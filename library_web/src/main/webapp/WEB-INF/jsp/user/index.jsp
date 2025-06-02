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
    <div class="container">
        <div class="logo">📚</div>
        <h1>도서관 자리예약</h1>
        <p class="subtitle">편리하고 빠른 좌석 예약 서비스</p>
        
        <div class="status-bar">
            <div class="status-info">
                <span class="status-label">현재 이용 가능한 좌석</span>
                <span class="status-value available">24석</span>
            </div>
            <div class="status-info">
                <span class="status-label">사용 중인 좌석</span>
                <span class="status-value occupied">16석</span>
            </div>
        </div>

        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/seats" class="menu-item">
                <span class="menu-item-icon">🪑</span>
                <span class="menu-item-text">좌석 현황</span>
            </a>
            <a href="${pageContext.request.contextPath}/reservation" class="menu-item">
                <span class="menu-item-icon">📝</span>
                <span class="menu-item-text">예약하기</span>
            </a>
            <a href="${pageContext.request.contextPath}/mypage" class="menu-item">
                <span class="menu-item-icon">👤</span>
                <span class="menu-item-text">내 예약</span>
            </a>
            <a href="/library/login" class="menu-item">
                <span class="menu-item-icon">🔐</span>
                <span class="menu-item-text">로그인</span>
            </a>
        </div>

        <div class="footer">
            <p>📞 문의: 032-123-4567 | 🕒 운영시간: 09:00 - 22:00</p>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>