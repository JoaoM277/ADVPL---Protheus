#Include "totvs.ch"
#Include "fwmvcdef.ch"
#Include "prtopdef.ch"

User Function U_ZZCCAD()

 Local cAlias := "ZZC"
 Local cTitulo:= "Cadastro de Cantores"
 Local cFunExc:= "u_ZZCe1()"
 Local cFunAlt:= "u_ZZCa1()"

 AxCadastro(cAlias, cTitulo, cFunExc, cFunAlt)
    
Return 


User Function u_ZZCe1()
    Local lRet := MsgYesNo("Tem Certeza que deseja excluir o registro selecionado?","Confirmação")
Return lRet


User Function u_ZZCa1()

  Local lRet := .F.
  Local cMsg := ""

  If INCLUI
    cMsg := "Confirma a inclusão do Registro"
  else
    cMsg := "Confirma a alteração do Registro"
  Endif

  lRet := MsgYesNo(cMsg, "Confirmação")
    
Return lRet 
