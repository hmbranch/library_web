<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 로그인 - 도서관 관리 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
</head>
<body>
    <div class="admin-login-container">
        <div class="admin-login-box">
            <div class="admin-logo">🔐</div>
            <h1>관리자 로그인</h1>
            <p class="admin-subtitle">도서관 관리 시스템</p>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <span>⚠️</span>
                    ${error}
                </div>
            </c:if>
            
            <form method="post" action="/admin/login" class="admin-login-form">
                <div class="form-group">
                    <label for="adminId">관리자 ID</label>
                    <input type="text" id="adminId" name="adminId" required 
                           placeholder="관리자 ID를 입력하세요">
                </div>
                
                <div class="form-group">
                    <label for="adminPw">비밀번호</label>
                    <input type="password" id="adminPw" name="adminPw" required 
                           placeholder="비밀번호를 입력하세요">
                </div>
                
                <button type="submit" class="admin-login-btn">
                    <span class="btn-icon">🔑</span>
                    로그인
                </button>
            </form>
            
            <div class="back-to-main">
                <a href="/library">← 사용자 페이지로 돌아가기</a>
            </div>
        </div>
    </div>
</body>
</html>