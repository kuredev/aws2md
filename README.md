# aws2md

Convert AWS CLI JSON output to Markdown tables – supports both vertical and horizontal formats.

## ✨ Features

- Converts complex AWS CLI JSON into Markdown tables
- Supports **vertical** and **horizontal** formats
- Handles nested arrays and objects
- Easy CLI integration via pipe (`|`)

## 📦 Installation

```bash
gem install aws2md
````

## 🚀 Usage

```bash
aws ec2 describe-vpcs | aws2md --output h
```

### Options

| Option           | Description               |
| ---------------- | ------------------------- |
| `-o`, `--output` | Output format: `h` or `v` |
| `-h`, `--help`   | Show usage help           |

* `h` = horizontal table
* `v` = vertical table

## 📚 Example

### Input (from AWS CLI)

```bash
aws ec2 describe-instances | aws2md --output v
```

### Output

```
# Reservations.0
+--------------+------------------------+
| Key          | Value                  |
+--------------+------------------------+
| InstanceId   | i-0123456789abcdef0    |
| InstanceType | t3.micro               |
...
```

## 🔧 Requirements

* Ruby 2.7 or later
* Works well with AWS CLI JSON output

## 🛠 Development

```bash
git clone https://github.com/YOUR_GITHUB/aws2md.git
cd aws2md
bundle install
```

Run with:

```bash
aws ec2 describe-vpcs | ruby exe/aws2md --output h
```

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🙋‍♀️ Author

[kuredev](https://github.com/kuredev)


