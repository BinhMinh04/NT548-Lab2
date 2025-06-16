# 🧪 NT548 - Lab 02: Quản lý và triển khai hạ tầng AWS và ứng dụng microservices với Terraform, CloudFormation, GitHub Actions, AWS CodePipeline và Jenkins 

## 👨‍💻 Thông tin sinh viên

* **Họ tên:** \Nguyễn Đặng Bình Minh - 22520871 \Trần Gia Bảo - 22520120
* **Lớp:** NT548 - Công nghệ DevOps và Ứng dụng

---

## 🎯 Mục tiêu bài Lab

* Viết hạ tầng AWS với **Terraform** (Task 1) và **CloudFormation** (Task 2)
* Quản lý trạng thái Terraform bằng S3 + DynamoDB
* Kiểm tra tính hợp lệ Terraform bằng `Checkov`
* Kiểm tra tính hợp lệ CloudFormation với `cfn-lint` và `taskcat`
* Tự động hoá kiểm tra & triển khai bằng GitHub Actions (Task 1) và CodePipeline (Task 2)

---

## ⚙️ Cách chạy mã nguồn

### ✅ Task 1 - Terraform + GitHub Actions
**Lưu ý**: Trước khi thực hiện bài lab. Hãy đảm bảo bạn đã **AWS configure** ACCESS_KEY_ID AND AWS_SECRET_ACCESS_KEY, REGION ĐỂ Có thể triển khai thành công mà không gặp lỗi. Và cung cấp setting Github Repo ACCESS_KEY_ID AND AWS_SECRET_ACCESS_KEY để có thể CI.
* Ở terraform bạn phải tiến hành đổi `ami-id`, `key_pair`, `IP address`, `region`
* Cloudformation cung cấp đúng `key_pair`, `region` `IAM`
-----------------------------
1. Tạo S3 bucket + DynamoDB table dùng cho remote backend - Chạy `terraform init`, `apply` file `terraform-bootstrap.tf`
2. File trạng thái `.tfstate` sẽ lưu ở S3 và khoá bởi DynamoDB sau khi GitHub Actions triển khai CI

CI sẽ chạy tự động khi **push lên branch `main`**:

* Kiểm tra `terraform fmt`, `validate`, `checkov`, `plan`
* Triển khai `terraform apply`
* Sau đó bạn có thể truy cập console của `AWS` để kiểm tra các tài nguyên đã tạo thành công và tiến hành kiểm thử ssh,...

### ✅ Task 2 - CloudFormation + CodePipeline

1. Push các file Task2 vào GitHub repo
2. **Build stage (CodeBuild)**:
   - Chạy `buildspec.yml`
   - Cài `cfn-lint`, `taskcat`
   - Kiểm tra cú pháp file `resource.yaml`
   - Kiểm tra khả năng triển khai qua `taskcat`
   - Sau khi `succeed` thì CodePipeline sẽ tiến hành tự động triển Cloudformation
3. CodePipeline thực hiện:
   * Dùng file `Task2/resource.yaml` 
   * **Deploy:** Dùng CloudFormation để triển khai hạ tầng
   * Sau đó có thể kiểm tra các tài nguyên được tạo ở CloudFormation Stack

---

## 🔍 Cách kiểm tra kết quả triển khai

### Task 1

* Vào **EC2 > Instances**:

  * EC2 Public có thể SSH được (qua IP public)
  * EC2 Private không có IP public, chỉ SSH từ EC2 Public
* Vào **VPC > Route Tables & Subnets**:

  * Subnet private route qua NAT Gateway
  * Subnet public gắn với IGW

### Task 2

* Vào **CloudFormation > Stacks**:

  * Tên stack: `NT548-Lab2`
  * Trạng thái: `CREATE_COMPLETE`
* Kiểm tra tương tự phần trên với EC2/VPC

---

## 💰 Chi phí & lưu ý

* **EC2 và NAT Gateway** có thể phát sinh chi phí
* Sau khi chạy xong, hãy **xoá CloudFormation stack và tài nguyên Terraform**

---

## 🧠 Ghi chú kỹ thuật

* Task 1:

  * Dùng Terraform module hoá các thành phần hạ tầng
  * Quản lý backend bằng S3 + DynamoDB
  * CI/CD bằng GitHub Actions
* Task 2:

  * Viết template CloudFormation thuần YAML
  * Kiểm tra template bằng `taskcat`
  * Quản lý backend bằng S3
  * Tích hợp CI/CD với AWS CodePipeline

---

