main:
    ;; 数据段寄存器设置为0x7c0，因为
    ;; 程序从此处偏移为0x7c00的位置开始加载
    ;; 但是默认地，ds本身是0x00，如果不这样会出问题
    mov ax, 0x7c0
    mov ds, ax

    ;; 访问显存的地址
    mov ax, 0xb800
    mov es, ax

    ;; 输出提示文本
    mov bx, text
    mov si, 0
    mov di, 0
    mov cx, text_end - text
show_char:
    mov al, [bx + si]
    mov ah, 0x07
    mov [es:di], ax
    add di, 2
    inc si
    loop show_char

    ;; 计算求和，结果放在ax里面
    mov cx, 1
    xor ax, ax
calc:
    add ax, cx
    inc cx
    cmp cx, 100
    jle calc

    ;; 逐位数字拆分
    mov bx, 10
    xor cx, cx
    mov ss, cx
    mov sp, cx
    mov cx, 0
split:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne split

    ;; 逐位数字输出
output:
    pop ax
    add al, 0x30
    mov ah, 0x07
    mov [es:di], ax
    add di, 2
    loop output

finish: jmp near finish

;;; 定义提示文本
text: db "1+2+3+...+100="
text_end:

fill:
    times 510 - ($ - $$) db 0   ; 凑满510字节（后面还有两个）
    db 0x55, 0xaa               ; MBR标准结尾字节
