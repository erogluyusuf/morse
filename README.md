![](https://github.com/erogluyusuf/morse/blob/main/morse.png)

# Morse Code Converter (`morse.sh`)

🌀 Bash tabanlı bir Morse kodu dönüştürücü ve sesli oynatıcıdır. Metinleri Morse koduna çevirebilir, tersine çevirebilir, dosyalardan okuyabilir ve sonuçları ses dosyasına kaydedebilir.

A Bash-based Morse code converter and audio generator. It can convert text to Morse code, decode Morse back to text, read from files, and generate Morse audio using SOX.

---

## 🧩 Özellikler / Features

- ✅ Harf, cümle veya dosyaları Morse koduna çevirme  
- 🔁 Morse kodunu tekrar normal metne dönüştürme  
- 🔊 SOX ile sesli Morse kodu oynatma ve `.wav` olarak kaydetme  
- 📁 Dosya okuma ve çıktı kaydetme  
- 🧠 Tüm Linux dağıtımlarıyla uyumludur  
- ⚙️ `sox` otomatik kontrol edilir, yüklü değilse sessizce kurulur  

---

## 🚀 Kullanım / Usage

### Yetkilendirme
```
chmod +x morse.sh
```

### Yardım / Help
```bash
  -h, --help              Show this help message
  -v, --version           Show script version
  -c, --character <char>  Convert a single character to Morse code
  -s, --sentence <text>   Convert a sentence to Morse code
  -f, --file <filename>   Convert a file's content to Morse code
  -F, --file-output       Convert a file's content to Morse code and save to a new file
  -r, --reverse <filename>Reverse Morse code back to regular text
  -R                      Reverse Morse code back to regular text and save to file
  --voice <text>          Convert text to Morse code and play sound
```
```
Examples:
  ./morse.sh -h
  Shows the help message explaining how to use the script.

  ./morse.sh --help
  Shows the help message explaining how to use the script.

  ./morse.sh -v
  Displays the script version.

  ./morse.sh --version
  Displays the script version.

  ./morse.sh -c A
  Converts the character 'A' to Morse code.

  ./morse.sh --character A
  Converts the character 'A' to Morse code.

  ./morse.sh -f input.txt
  Converts the content of the file 'input.txt' to Morse code.

  ./morse.sh --file input.txt
  Converts the content of the file 'input.txt' to Morse code.

  ./morse.sh -F  input.txt
  Converts the content of the file 'input.txt' to Morse code and saves the result to 'output.txt'.

  ./morse.sh --file-output input.txt
  Converts the content of the file 'input.txt' to Morse code and saves the result to 'output.txt'.

  ./morse.sh -r morse.txt
  Reverses the Morse code content in 'morse.txt' back to regular text.

  ./morse.sh --reverse morse.txt
  
  ./morse.sh --voice "SOS"
  Converts the text "SOS" to Morse code and generates a sound file named output.wav where the Morse code is played as audio.

```
