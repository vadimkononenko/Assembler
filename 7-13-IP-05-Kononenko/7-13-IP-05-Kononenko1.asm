include \masm32\include\masm32rt.inc
include \masm32\include\Fpu.inc
includelib \masm32\lib\Fpu.lib

public array_b, array_d, number2, count, inter_solved3
extern res:PROTO

main_solver macro index
        mov eax, offset inter_solved1
        mov ebx, offset array_a[8*index]
        mov ecx, offset number2
        mov edx, offset array_c[8*index]       
        call left_solver
        
        push offset inter_solved2
        push number3 
        push DWORD ptr array_b[8*index + 4]
        push DWORD ptr array_b[8*index]        
        call right_solver
        
        mov count, index        
        call res
        
        fld inter_solved1
        fld inter_solved2       
        fadd
        
        fld inter_solved3
        fdivp st(1), st
        
        fst solved
        
        invoke crt_sprintf, addr res_solved_values[100*index], 
                            addr solved_value_template, 
                            solved
        invoke crt_sprintf, addr res_given_values[200*index], 
                            addr given_values_template, 
                            array_a[8*index], 
                            array_b[8*index], 
                            array_c[8*index], 
                            array_d[8*index]
endm

.data                
        ClassName db "simple", 0
        header db "Expression solver by Vadim Kononenko IP-05 Laba 7", 0
        given_values_template db "A: ( %f )", 10, 
                                 "      B: ( %f )", 10, 
                                 "      C: ( %f )", 10, 
                                 "      D: ( %f )", 0
        solved_value_template db "(2a-c + b/3) / (arctg(b - d/2)) = ( %f )", 0
        expression db "Expression: (2a-c + b/3) / (arctg(b - d/2))", 0
        number2 dd 2
        number3 dd 3
        array_a dq 25.12,    3.213,      796.5342,       40056321.4562,      -0.0000023112
        array_b dq 15.43,    0.2381,     6.26,           4.87556,            4.4353111
        array_c dq 2.2,      -184.0012,  -7.42,          -5421.62,           -0.32411
        array_d dq 6.4,      18.84,      0.51,           1.03331,            0.45211
        
.data?             
        hInstance HINSTANCE ?     
        CommandLine LPSTR ?
        solved dq ?
        count db ?
        res_given_values db 1200 dup (?)
        res_solved_values db 1200 dup (?)
        inter_solved1 dq ?
        inter_solved2 dq ?
        inter_solved3 dq ?
        
WinMain proto :dword,:dword,:dword,:dword

.code      
    left_solver proc
        finit
        fld qword ptr [ebx]
        fimul dword ptr [ecx]
        fld qword ptr [edx]
        fsubp st(1), st
        fst qword ptr [eax]
        ret
    left_solver endp
          
    right_solver proc
        push ebp
        mov ebp, esp    
        finit
        fld qword ptr [ebp + 8]
        fild dword ptr [ebp + 16]
        fdivp st(1), st
        mov eax, [ebp + 20]
        fst qword ptr [eax]
        mov esp, ebp
        pop ebp
        ret 16
    right_solver endp

    start:
        invoke GetModuleHandle, NULL 
        mov hInstance, eax
        invoke GetCommandLine   
       
        mov CommandLine, eax
        invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
        invoke ExitProcess, eax

        WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
                local wcx:WNDCLASSEX   
                local msg:MSG
                local hwnd:HWND

                mov   wcx.cbSize,SIZEOF WNDCLASSEX
                mov   wcx.style, CS_HREDRAW or CS_VREDRAW
                mov   wcx.lpfnWndProc, OFFSET WndProc
                mov   wcx.cbClsExtra,NULL

                mov   wcx.cbWndExtra,NULL
                push  hInstance
                pop   wcx.hInstance
                mov   wcx.hbrBackground,COLOR_WINDOW+1

                mov   wcx.lpszMenuName,NULL
                mov   wcx.lpszClassName,OFFSET ClassName
                invoke LoadIcon,NULL,IDI_APPLICATION
                mov   wcx.hIcon,eax

                mov   wcx.hIconSm,eax
                invoke LoadCursor,NULL,IDC_ARROW
                mov   wcx.hCursor,eax
                invoke RegisterClassEx, addr wcx
                invoke CreateWindowEx, NULL,ADDR ClassName, ADDR header, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT,
                                    600,
                                    400,
                                    NULL,
                                    NULL,
                                    hInst,
                                    NULL
                mov   hwnd, eax
                invoke ShowWindow, hwnd,CmdShow  
                invoke UpdateWindow, hwnd 

                .WHILE TRUE 
                        invoke GetMessage, ADDR msg,NULL,0,0
                        .BREAK .IF (!eax)

                        invoke TranslateMessage, ADDR msg
                        invoke DispatchMessage, ADDR msg
                .ENDW
                
                mov     eax,msg.wParam 
                ret
        WinMain endp

        WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
                local hdc:HDC
                local ps:PAINTSTRUCT
	          .if uMsg==WM_CREATE
                        index = 5;
                        while index;
                            index = index - 1
                            main_solver index
                        endm
                .elseif uMsg==WM_DESTROY 
                        invoke PostQuitMessage, NULL 
                .elseif uMsg==WM_PAINT
                        invoke BeginPaint, hWnd, addr ps
                        mov hdc, eax
        
                        invoke TextOut, hdc, 150, 20, addr expression, 43
        
                        invoke TextOut, hdc, 20, 60, addr res_given_values, 200
                        invoke TextOut, hdc, 20, 80, addr res_solved_values, 60
        
                        invoke TextOut, hdc, 20, 120, addr res_given_values[200], 200
                        invoke TextOut, hdc, 20, 140, addr res_solved_values[100], 60

                        invoke TextOut, hdc, 20, 180, addr res_given_values[400], 200
                        invoke TextOut, hdc, 20, 200, addr res_solved_values[200], 60
                   
                        invoke TextOut, hdc, 20, 240, addr res_given_values[600], 200
                        invoke TextOut, hdc, 20, 260, addr res_solved_values[300], 60
        
                        invoke TextOut, hdc, 20, 300, addr res_given_values[800], 200
                        invoke TextOut, hdc, 20, 320, addr res_solved_values[400], 60       

                        invoke EndPaint, hWnd, addr ps
                .else
                        invoke DefWindowProc, hWnd, uMsg, wParam, lParam 
                        ret
                .endif
                        xor eax, eax
                        ret
        WndProc endp
end start