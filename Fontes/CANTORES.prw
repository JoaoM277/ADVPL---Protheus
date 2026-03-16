#Include "totvs.ch"
#Include "fwmvcdef.ch"


Static cAliasMVC := "ZZC"
Static cTitulo := "CANTORES"

User Function CANTORES()
    local aArea   := GetArea()
    local oBrowse

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasMVC)
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()
       
    RestArea(aArea)

return Nil
	
//MenuDef
Static Function MenuDef()
   Local aRotina := {} //Variavel de Rotina

   //Opções do Menu, Ex:
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.CANTORES" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.CANTORES" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.CANTORES" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.CANTORES" OPERATION 5 ACCESS 0
Return aRotina

//ModelDef
Static Function ModelDef()
  Local oStruct := FWFormStruct(1, cAliasMVC)
  Local oModel
  Local bPre := Nil
  Local bPos := Nil
  Local bCommit := Nil
  Local bCancel := Nil

  bCommit := {|oModel| fCommit(oModel)}

  //Cria o modelo de dados para o cadastro
  oModel := MPFormModel():New("MODELMVC", bPre, bPos, bCommit, bCancel) // Aqui coloquei outro nome para nao dar algum tipo de conflito com a função
  oModel :AddFields("MASTER", /*cOwner*/, oStruct) // Aqui coloquei "MASTER" os dev usa assim nos codigos
  oModel :SetDescription("Modelo de dados - " + cTitulo)
  oModel :GetModel("MASTER"):SetDescription( "Dados de - " + cTitulo)
  oModel :SetPrimaryKey({})
Return oModel

//ViewDef
Static Function ViewDef() 
    Local oModel := FWLoadModel("CANTORES")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView

    //Cria a visualização do cadastro
    oView := FWFormView():New()
    oView :SetModel(oModel)
    oView :AddField("VIEW_CANTORES", oStruct, "MASTER")
    oView :CreateHorizontalBox("TELA" , 100)
    oView :SetOwnerView("VIEW_CANTORES", "TELA")

Return oView

//Função de notificação
Static Function fCommit(oModel)

    Local nOperation := oModel:GetOperation()
    Local lRet       := .T.
    Local cName      := oModel:GetValue("MASTER","ZZC_NOME") //Busca a descrição na tabela
    Local nRecAtual  := ZZC->(Recno()) //Guarda o local do ponteiro (onde o sistema ta lendo)
    Local lExist     := .T.

    if nOperation == MODEL_OPERATION_INSERT .or. nOperation ==  MODEL_OPERATION_UPDATE //Retorna true caso a operação seja de Criar ou  de Editar registros, apenas

      if nOperation == MODEL_OPERATION_UPDATE
         MsgYesNo("Tem certeza que deseja alterar o registro atual?", "Confirmação")
      endif

      ZZC->(dbSetOrder(2))
		 if ZZC->(dbSeek(xFilial("ZZC")+cName))
		    if nOperation==MODEL_OPERATION_INSERT .or. (ZZC->(Recno())  !=nRecAtual)
          lExist := .F.
			  endif
     endif
    endif

    if !lExist 
      oModel:setErrorMessage(,,, , ,;
        "Duplicidade Detectada",;
        "Este registro (Título/Álbum ou Código) já existe no sistema.",;
        "Por favor, verifique os dados antes de salvar.", , , )
      lRet := .F.
    endif
  
  

Return lRet

