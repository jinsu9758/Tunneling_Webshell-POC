<%@ page import="java.io.*,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 업로드될 폴더 경로 설정 (ROOT/upload)
    String uploadPath = application.getRealPath("/") + "upload";
    File uploadDir = new File(uploadPath);
    
    // upload 폴더가 없으면 자동 생성
    if (!uploadDir.exists()) {
        uploadDir.mkdir();
    }

    String contentType = request.getContentType();
    // multipart/form-data 요청인지 확인 (파일 업로드 요청인지)
    if (contentType != null && contentType.indexOf("multipart/form-data") >= 0) {
        DataInputStream in = new DataInputStream(request.getInputStream());
        int formDataLength = request.getContentLength();
        byte dataBytes[] = new byte[formDataLength];
        int byteRead = 0;
        int totalBytesRead = 0;
        
        // 데이터 읽기
        while (totalBytesRead < formDataLength) {
            byteRead = in.read(dataBytes, totalBytesRead, formDataLength - totalBytesRead);
            totalBytesRead += byteRead;
        }
        
        String file = new String(dataBytes, "CP1256");
        String saveFile = file.substring(file.indexOf("filename=\"") + 10);
        saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
        saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1, saveFile.indexOf("\""));
        
        int lastIndex = contentType.lastIndexOf("=");
        String boundary = contentType.substring(lastIndex + 1, contentType.length());
        
        int pos;
        pos = file.indexOf("filename=\"");
        pos = file.indexOf("\n", pos) + 1;
        pos = file.indexOf("\n", pos) + 1;
        pos = file.indexOf("\n", pos) + 1;
        
        int boundaryLocation = file.indexOf(boundary, pos) - 4;
        int startPos = ((file.substring(0, pos)).getBytes("CP1256")).length;
        int endPos = ((file.substring(0, boundaryLocation)).getBytes("CP1256")).length;

        // 실제 파일 저장
        FileOutputStream fileOut = new FileOutputStream(uploadPath + "/" + saveFile);
        fileOut.write(dataBytes, startPos, (endPos - startPos));
        fileOut.flush();
        fileOut.close();

        // 성공 메시지 및 업로드된 파일 링크 출력
        out.println("<div style='background-color:#d4edda; padding:10px; border:1px solid #c3e6cb; border-radius:5px;'>");
        out.println("<b>🔥 File Uploaded Successfully!</b><br>");
        out.println("<b>Access Link:</b> <a href='/upload/" + saveFile + "' target='_blank'>/upload/" + saveFile + "</a>");
        out.println("</div><br>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Vulnerable Upload Page</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .upload-box { border: 1px dashed #ccc; padding: 20px; background-color: #f9f9f9; width: 400px; }
    </style>
</head>
<body>
    <h2>📁 CTF File Upload Target</h2>
    <p>Upload your webshell or tunneling script (.jsp) here.</p>
    
    <div class="upload-box">
        <form method="POST" enctype="multipart/form-data" action="">
            <input type="file" name="file" required /><br><br>
            <input type="submit" value="Upload to Server" />
        </form>
    </div>
</body>
</html>