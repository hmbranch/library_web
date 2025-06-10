<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>좌석 현황 - 도서관 시스템</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/seat.css">
</head>
<body>
    <div class="header">
        <h1>📚 도서관 관리 시스템</h1>
        <div class="user-info">
            <span>안녕하세요, <strong>${loginUser.name}</strong>님!</span>
            <a href="/library/logout" class="logout-btn">로그아웃</a>
        </div>
    </div>
    
    <div class="container">
        <div class="page-header">
            <h2>🪑 좌석 현황</h2>
            <div class="nav-buttons">
                <a href="/library" class="btn btn-secondary">홈으로</a>
                <a href="/seats/reservation" class="btn btn-primary">좌석 예약</a>
            </div>
        </div>
        
        <!-- 성공/실패 메시지 -->
        <c:if test="${param.success == 'reserved'}">
            <div class="alert alert-success">
                ✅ 좌석이 성공적으로 예약되었습니다!
            </div>
        </c:if>
        
        <c:if test="${param.success == 'cancelled'}">
            <div class="alert alert-success">
                ✅ 좌석 예약이 성공적으로 취소되었습니다!
            </div>
        </c:if>
        
        <c:if test="${param.error == 'cancel_failed'}">
            <div class="alert alert-error">
                ❌ 좌석 예약 취소에 실패했습니다.
            </div>
        </c:if>
        
        <!-- 통계 정보 -->
        <div class="stats-container">
            <div class="stat-card available">
                <div class="stat-number">${stats.availableSeats}</div>
                <div class="stat-label">사용 가능</div>
            </div>
            <div class="stat-card occupied">
                <div class="stat-number">${stats.occupiedSeats}</div>
                <div class="stat-label">사용 중</div>
            </div>
            <div class="stat-card total">
                <div class="stat-number">${stats.totalSeats}</div>
                <div class="stat-label">전체 좌석</div>
            </div>
        </div>
        
        <!-- 범례 -->
        <div class="legend">
            <div class="legend-item">
                <div class="legend-color available"></div>
                <span>사용 가능</span>
            </div>
            <div class="legend-item">
                <div class="legend-color occupied"></div>
                <span>사용 중</span>
            </div>
            <div class="legend-item">
                <div class="legend-color reserved"></div>
                <span>예약됨</span>
            </div>
            <div class="legend-item">
                <div class="legend-color maintenance"></div>
                <span>점검 중</span>
            </div>
        </div>
        
        <!-- 좌석 배치도 -->
        <div class="seat-layout">
            <div class="seat-row">
                <div class="row-label">A열</div>
                <c:forEach items="${seats}" var="seat" begin="0" end="4">
                    <div class="seat ${seat.statusClass}" data-seat-id="${seat.seatId}">
                        <div class="seat-number">${seat.seatName}</div>
                        <div class="seat-status">${seat.statusText}</div>
                        <c:if test="${seat.userId == loginUser.userId}">
                            <div class="my-reservation">내 예약</div>
                        </c:if>
                        <c:if test="${seat.arduinoSignal}">
                            <div class="arduino-indicator">📡</div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
            
            <div class="seat-row">
                <div class="row-label">B열</div>
                <c:forEach items="${seats}" var="seat" begin="5" end="9">
                    <div class="seat ${seat.statusClass}" data-seat-id="${seat.seatId}">
                        <div class="seat-number">${seat.seatName}</div>
                        <div class="seat-status">${seat.statusText}</div>
                        <c:if test="${seat.userId == loginUser.userId}">
                            <div class="my-reservation">내 예약</div>
                            <form method="post" action="/seats/cancel" style="margin-top: 5px;">
                                <input type="hidden" name="seatId" value="${seat.seatId}">
                                <button type="submit" class="cancel-btn" onclick="return confirm('예약을 취소하시겠습니까?')">
                                    취소
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${seat.arduinoSignal}">
                            <div class="arduino-indicator">📡</div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
        
        <!-- 실시간 업데이트 상태 -->
        <div class="update-info">
            <span id="lastUpdate">마지막 업데이트: <span id="updateTime">--:--:--</span></span>
            <button id="refreshBtn" class="btn btn-small">새로고침</button>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/js/seat.js"></script>
    <script>
        // 페이지 로드시 시간 업데이트
        document.getElementById('updateTime').textContent = new Date().toLocaleTimeString();
        
        // 새로고침 버튼 이벤트
        document.getElementById('refreshBtn').addEventListener('click', function() {
            location.reload();
        });
        
        // 5초마다 자동 새로고침 (선택사항)
        setInterval(function() {
            // AJAX로 좌석 상태만 업데이트하는 것도 가능
            // location.reload();
        }, 5000);
    </script>
</body>
</html>