main:
    ;; 数据段寄存器设置为0x7c0，因为
    ;; 程序从此处偏移为0x7c00的位置开始加载
    ;; 但是默认地，ds本身是0x00，如果不这样会出问题
    mov ax, 0x7c0
    mov ds, ax

    ;; 访问显存的地址
    mov ax, 0xb800
    mov es, ax

    ;; 显示文本
    cld
    mov si, text
    mov di, 0
    mov cx, (text_end - text) / 2
    rep movsw

    ;; 拆分数字
    mov ax, 0x7c0
    mov ds, ax
    mov bx, digits
    mov si, 0x0
    mov cx, 10
    mov ax, [number]
loop:
    cmp ax, 0
    je show
    xor dx, dx
    div cx
    mov [bx + si], dx
    inc si
    jmp loop

    ;; 输出
show:
    dec si
.show:
    ;; 低位（对应低地址）是字符的ASCII
    mov al, [bx + si]
    add al, 0x30
    ;; 高位（高地址）是字符的颜色属性
    mov ah, 0x04
    ;; 把ax=ah+al传递给[es:di]，双字节
    mov [es:di], ax
    add di, 2
    dec si
    jns .show

finish: jmp near finish

;;; 定义提示文本、颜色
text:
    db 'W', 0x07
    db 'e', 0x07
    db 'l', 0x07
    db 'c', 0x07
    db 'o', 0x07
    db 'm', 0x07
    db 'e', 0x07
    db ' ', 0x07
    db 't', 0x07
    db 'o', 0x07
    db ' ', 0x07
    db 'G', 0x07
    db 'N', 0x07
    db 'U', 0x07
    db '/', 0x07
    db 'S', 0x07
    db 'i', 0x07
    db 'n', 0x07
    db 'u', 0x07
    db 'x', 0x07
    db '.', 0x07
    db '.', 0x07
    db '.', 0x07
text_end:

number dw 1234
digits db 0, 0, 0, 0, 0

fill:
    times 510 - ($ - $$) db 0   ; 凑满510字节（后面还有两个）
    db 0x55, 0xaa               ; MBR标准结尾字节
