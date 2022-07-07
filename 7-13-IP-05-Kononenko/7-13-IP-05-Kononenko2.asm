.386
.model flat,stdcall

option casemap:none

public res
extern array_b:qword, array_d:qword, number2:dword, count:byte, inter_solved3:qword

.code
        res proc
        finit
        mov al, count
        cbw
        cwde

        fld qword ptr array_b[eax * 8]; b â st(0)
        fld qword ptr array_d[eax * 8]; d â st(0), b â st(1)
        fidiv number2; d / 2 â st(0), b â st(1)
        fsubp st(1), st; b - d / 2 â st(0)
        fld1
        fpatan; arctg(b - d / 2) â st(0)
        fst inter_solved3
        ret
        res endp
end