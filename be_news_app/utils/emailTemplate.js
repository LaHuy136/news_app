function generateEmailTemplate(username, code) {
  return `
  <div style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 30px;">
    <div style="max-width: 500px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
      <h2 style="color: #4CAF50;">👋 Xin chào ${username || 'bạn'},</h2>
      <p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu của bạn.</p>
      <p>Vui lòng sử dụng mã xác thực sau để tiếp tục:</p>
      <div style="font-size: 32px; font-weight: bold; margin: 20px 0; color: #333; letter-spacing: 4px;">
        ${code}
      </div>
      <p>Mã này sẽ hết hạn sau <strong>5 phút</strong>.</p>
      <p>Nếu bạn không yêu cầu hành động này, vui lòng bỏ qua email này.</p>
      <hr style="margin-top: 40px;"/>
      <p style="color: #888;">© ${new Date().getFullYear()} Ứng dụng Quản lý Công việc</p>
    </div>
  </div>
  `;
}

module.exports = generateEmailTemplate;
