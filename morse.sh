#!/bin/bash

# Versiyon ve yardım mesajları
version="1.0"
help_message="Usage: ./morse.sh [options]
Options:
  -h, --help              Show this help message
  -v, --version           Show script version
  -c, --character <char>  Convert a single character to Morse code
  -s, --sentence <text>   Convert a sentence to Morse code
  -f, --file <filename>   Convert a file's content to Morse code
  -F, --file-output       Convert a file's content to Morse code and save to a new file
  -r, --reverse <filename>Reverse Morse code back to regular text
  -R                      Reverse Morse code back to regular text and save to file
  --voice <text>          Convert text to Morse code and play sound



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

"

# Ses dosyalarının yolu
dot_sound="dot.wav"     # Nokta için ses dosyası
dash_sound="dash.wav"   # Tire için ses dosyası




# Morse kodu harf ve rakamları
declare -A morse
morse=(
    [A]=".-"     [B]="-..."   [C]="-.-."   [D]="-.."    [E]="."      [F]="..-."   [G]="--."    [H]="...."
    [I]=".."     [J]=".---"   [K]="-.-"    [L]=".-.."   [M]="--"     [N]="-."     [O]="---"    [P]=".--."
    [Q]="--.-"   [R]=".-."    [S]="..."    [T]="-"      [U]="..-"    [V]="...-"   [W]=".--"    [X]="-..-"
    [Y]="-.--"   [Z]="--.."  

    [1]=".----"  [2]="..---"  [3]="...--"  [4]="....-"  [5]="....."  [6]="-...."  [7]="--..."  [8]="---.." 
    [9]="----."  [0]="-----"

    ["."]=".-.-.-"   [","]="--..--"   ["?"]="..--.."   ["!"]="-.-.--"   ["'"]=".----."   ["\""]=".-..-."
    ["("]="-.--."    [")"]="-.--.-"   ["&"]=".-..."    [;]="-.-.-."     [":"]="---..."    ["/"]="-..-."
    ["="]="-...-"    ["+"]=".--.-."   ["-"]="-....-"   ["_"]="..--.-"   ["$"]="...-..-"   ["@"]=".--.-."
    [" "]="/"

    # Latin dışı özel karakterler için morse kodları
    [Æ]=".-.-"    [æ]=".-.-"    [Đ]="-..-"    [đ]="-..-"    [Ñ]="--.--"    [ñ]="--.--"
    [Ø]="---."    [ø]="---."    [Ł]=".-..-"   [ł]=".-..-"   [Ź]="--..-"   [ź]="--..-"
    [Ĥ]="....-"   [ĥ]="....-"
    
    # Türkçe karakterler için morse kodları
    [ç]="-.-..-"    [ğ]="--."     [ı]=".."    [ö]="---."    [ş]="---...."    [ü]="..--"
)




# Parametreleri işleme1
while [[ $# -gt 0 ]]; do
  case "$1" in

    -h|--help)
      echo "$help_message"
      exit 0
      ;;
    -v|--version)
      echo "Morse Converter Script Version: $version"
      exit 0
      ;;
    -c|--character)
      input="$2"
      if [[ -z "$input" ]]; then
        echo "Hata: Karakter eksik."
        exit 1
      fi

      # Türkçe karakterleri de büyük harfe çevir (gawk gerektirir)
      export LC_ALL=C.UTF-8
      input=$(echo "$input" | awk '{ print toupper($0) }')

      # Mors kodu karşılığı var mı kontrol et
      if [[ -n "${morse[$input]}" ]]; then
        echo " ${morse[$input]}"
      else
        echo "Uyarı: '$input' karakteri için Mors kodu bulunamadı."
      fi
      exit 0
      ;;

    -s|--sentence)
      input="$2"
      if [[ -z "$input" ]]; then
        echo "Hata: Cümle eksik."
        exit 1
      fi

      # Tüm harfleri büyük yap (Türkçe karakterler dahil)
      export LC_ALL=C.UTF-8
      input=$(echo "$input" | awk '{ print toupper($0) }')

      output=""
      for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"

        # Harf boşluksa ayraç ekle
        if [[ "$char" == " " ]]; then
          output+="   "  # Kelimeler arası 3 boşluk
        elif [[ -n "${morse[$char]}" ]]; then
          output+="${morse[$char]} "
        else
          output+="? "  # Tanımsız karakterleri ? ile belirt
        fi
      done

      echo "$output"
      exit 0
      ;;

    -f|--file)
      filename="$2"
      if [[ ! -f "$filename" ]]; then
        echo "Error: File not found."
        exit 1
      fi
      while IFS= read -r line; do
        echo "Line: $line"
        line=$(echo "$line" | tr 'çğıöşü' 'ÇĞİÖŞÜ' | tr 'a-z' 'A-Z')
        for (( i=0; i<${#line}; i++ )); do
          char="${line:$i:1}"
          echo -n "${morse[$char]} "
        done
        echo
      done < "$filename"
      exit 0
      ;;

-F|--file-output)
  filename="$2"
  if [[ ! -f "$filename" ]]; then
    echo "Error: File not found."
    exit 1
  fi
  
  # Çıktı dosyasını belirliyoruz
  base_filename=$(basename "$filename" .txt)
  output_file="${base_filename}_morse_output.txt"
  
  # Çıktı dosyasını temizliyoruz (varsa eski içeriği siler)
  > "$output_file"
  
  while IFS= read -r line; do
    echo "Processing line: $line" >> "$output_file"  # Hangi satır işlendiğini dosyaya yazıyoruz
    
    line=$(echo "$line" | tr 'çğıöşü' 'ÇĞİÖŞÜ' | tr 'a-z' 'A-Z')
    for (( i=0; i<${#line}; i++ )); do
      char="${line:$i:1}"
      # Mors kodunu dosyaya yazıyoruz
      echo -n "${morse[$char]} " >> "$output_file"
    done
    echo >> "$output_file"  # Satır sonuna yeni satır ekliyoruz
  done < "$filename"

  echo "Morse code output written to $output_file"
  exit 0
  ;;


-r|--reverse)
  # Mors kodunu metne dönüştürmek için ters diziyi kullanıyoruz
  declare -A reverse_morse
  for char in "${!morse[@]}"; do
      reverse_morse[${morse[$char]}]=$char
  done

  filename="$2"
  if [[ ! -f "$filename" ]]; then
    echo "Error: File not found."
    exit 1
  fi

  # Dosya içeriğini okuma
  while IFS= read -r line; do
    output=""
    
    # Satırdaki her bir Mors kodunu ayırarak işliyoruz
    for mors in $line; do
      # Eğer mors kodu dizide mevcutsa, harfe çevir
      if [[ -n "${reverse_morse[$mors]}" ]]; then
        output+="${reverse_morse[$mors]}"
      elif [[ "$mors" == "/" ]]; then
        output+=" "  # "/" karakteri boşluk olarak çözülmeli
      fi
    done

    # Çözülmüş metni sadece yazdır
    echo "$output"
  done < "$filename"

  exit 0
;;

-R)
  # Mors kodunu metne dönüştürmek için ters diziyi kullanıyoruz
  declare -A reverse_morse
  for char in "${!morse[@]}"; do
      reverse_morse[${morse[$char]}]=$char
  done

  filename="$2"
    base_filename=$(basename "$filename" .txt)
  output_file="${base_filename}_decoded_output.txt"  # Çıktının yazılacağı dosya adı

  if [[ ! -f "$filename" ]]; then
    echo "Error: File not found."
    exit 1
  fi

  # Çıktı dosyasını temizle (varsa eski içeriği siler)
  > "$output_file"

  # Dosya içeriğini okuma
  while IFS= read -r line; do
    output=""
    
    # Satırdaki her bir Mors kodunu ayırarak işliyoruz
    for mors in $line; do
      # Eğer mors kodu dizide mevcutsa, harfe çevir
      if [[ -n "${reverse_morse[$mors]}" ]]; then
        output+="${reverse_morse[$mors]}"
      elif [[ "$mors" == "/" ]]; then
        output+=" "  # "/" karakteri boşluk olarak çözülmeli
      fi
    done

    # Çözülmüş metni dosyaya yaz
    echo "$output" >> "$output_file"
  done < "$filename"

  echo "Decoded output written to $output_file"
  exit 0
;;

    --timestamp)
      # Zaman damgası ekler
      timestamp=$(date +"%Y-%m-%d %H:%M:%S")  # Şu anki tarihi ve saati alır
      echo "Timestamp: $timestamp"
      
      # Çevirme işlemi de yapılabilir
      # Örneğin, Mors kodu çıktısı ile zaman damgası birleştirilerek eklenebilir:
      morse_output=$(echo "$input" | tr 'A-Za-z' '.-')
      echo "$timestamp - Morse translation: $morse_output"
      ;;

--voice)
    input="$2"
    shift 2
    if [[ -z "$input" ]]; then
        echo "Hata: Cümle eksik."
        exit 1
    fi

    # Tüm harfleri büyük yap (Türkçe karakterler dahil)
    export LC_ALL=C.UTF-8
    input=$(echo "$input" | awk '{ print toupper($0) }')

    echo "Metin: $input"
    for ((i=0; i<${#input}; i++)); do
        ch="${input:$i:1}"
        code="${morse[$ch]}"
        if [[ -n "$code" ]]; then
            # Karakteri Mors koduna çevir
            echo "$ch => $code"
            for ((j=0; j<${#code}; j++)); do
                sym="${code:$j:1}"
                if [[ "$sym" == "." ]]; then
                    aplay "$dot_sound" >/dev/null 2>&1
                elif [[ "$sym" == "-" ]]; then
                    aplay "$dash_sound" >/dev/null 2>&1
                fi
                sleep 0.05  # Nokta ve tireler arasındaki bekleme
            done
            sleep 0.2  # Harfler arası bekleme
        elif [[ "$ch" == " " ]]; then
            # Kelimeler arası boşluk
            sleep 0.5
        else
            echo "Karakter tanımlanamıyor: $ch"
        fi
    done
    ;;

--record)
            input="$2"
            shift 2

            if [[ -z "$input" ]]; then
                echo "Hata: Cümle eksik."
                exit 1
            fi

            # Tüm harfleri büyük yap (Türkçe karakterler dahil)
            export LC_ALL=C.UTF-8
            input=$(echo "$input" | awk '{ print toupper($0) }')

            echo "Metin: $input"
            
            # Geçici ses dosyalarını saklayacak dizini oluştur
            temp_dir="temp_sounds"
            mkdir -p "$temp_dir"

            # İlk başta output dosyasını boş oluştur
            output="output.wav"
            sox -n -r 44100 -c 1 "$output" trim 0 0

            # Her sembol için ses dosyasını kaydet ve birleştir
            for ((i=0; i<${#input}; i++)); do
                ch="${input:$i:1}"
                code="${morse[$ch]}"
                if [[ -n "$code" ]]; then
                    # Karakteri Mors koduna çevir
                    echo "$ch => $code"
                    for ((j=0; j<${#code}; j++)); do
                        sym="${code:$j:1}"
                        if [[ "$sym" == "." ]]; then
                            # Nokta sesi oluştur ve kaydet
                            dot_file="$temp_dir/dot_$i.wav"
                            sox -n -r 44100 -c 1 "$dot_file" synth 0.3 sine 1000
                        elif [[ "$sym" == "-" ]]; then
                            # Tire sesi oluştur ve kaydet
                            dash_file="$temp_dir/dash_$i.wav"
                            sox -n -r 44100 -c 1 "$dash_file" synth 0.7 sine 1000
                        fi
                        # Sesi output'a ekle
                        sox "$output" "$dot_file" "$output"  # Nokta sesi ekle
                        sox "$output" "$dash_file" "$output"  # Tire sesi ekle
                        # Nokta ve tireler arasındaki bekleme
                        sox "$output" -n pad 0 0.05
                    done
                    # Harfler arası bekleme ekle
                    sox "$output" -n pad 0 0.2
                elif [[ "$ch" == " " ]]; then
                    # Kelimeler arası boşluk
                    sox "$output" -n pad 0 0.5
                else
                    echo "Karakter tanımlanamıyor: $ch"
                fi
            done
            
            # Geçici dosyaları temizle
            rm -rf "$temp_dir"
            
            echo "Mors kodu ses dosyasına kaydedildi: $output"
            ;;
 



  esac
  shift
done
# Eğer hiçbir seçenek verilmediyse, yardım mesajını göster
if [[ $# -eq 0 ]]; then
  echo "$help_message"
  exit 0
fi
