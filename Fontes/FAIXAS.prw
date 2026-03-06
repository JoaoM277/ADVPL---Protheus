#Include "totvs.ch"
#Include "fwmvcdef.ch"


Static cAliasMVC := "ZZM"
Static cTitulo := "Faixas"

User Function FAIXAS()
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
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.FAIXAS" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.FAIXAS" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.FAIXAS" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.FAIXAS" OPERATION 5 ACCESS 0
Return aRotina

//ModelDef
Static Function ModelDef()
  Local oStruct := FWFormStruct(1, cAliasMVC)
  Local oModel
  Local bPre := Nil
  Local bPos := Nil
  Local bCommit := Nil
  Local bCancel := Nil

  bCommit := {|oModel| fCommit(oModel)} //Chama a função de Validação "fCommit"

  //Cria o modelo de dados para o cadastro
  oModel := MPFormModel():New("MODELMVC", bPre, bPos, bCommit, bCancel) // Aqui coloquei outro nome para nao dar algum tipo de conflito com a função
  oModel :AddFields("MASTER", /*cOwner*/, oStruct) // Aqui coloquei "MASTER" os dev usa assim nos codigos
  oModel :SetDescription("Modelo de dados - " + cTitulo)
  oModel :GetModel("MASTER"):SetDescription( "Dados de - " + cTitulo)
  oModel :SetPrimaryKey({})
Return oModel

//ViewDef
Static Function ViewDef() 
    Local oModel := FWLoadModel("FAIXAS")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView

    //Cria a visualização do cadastro
    oView := FWFormView():New()
    oView :SetModel(oModel)
    oView :AddField("VIEW_FAIXAS", oStruct, "MASTER")
    oView :CreateHorizontalBox("TELA" , 100)
    oView :SetOwnerView("VIEW_FAIXAS", "TELA")

Return oView

//Função de Validação de 1 Faixa por Album
Static Function fCommit(oModel)
    Local nOperation := oModel:GetOperation()
    Local lRet       := .T.
    Local cDesc      := oModel:GetValue("MASTER","ZZM_NOME") //Busca a descrição na tabela
    Local cAlbCod    := oModel:GetValue("MASTER","ZZM_ALBCOD") //Busca o codigo do Artista na tabela
    Local cCod       := oModel:GetValue("MASTER","ZZM_COD") //Busca o codigo do Registro nesse caso o album
    Local nRecAtual  := ZZA->(Recno()) //Guarda o local do ponteiro (onde o sistema ta lendo)

    if nOperation == MODEL_OPERATION_INSERT .or. nOperation == MODEL_OPERATION_UPDATE //Retorna true caso a operação seja de Criar ou de Editar registros, apenas
      if Valida(nOperation, nRecAtual, cDesc, cAlbCod, cCod)
       lRet := ShowError(oModel) 
      endif

      if lRet
        Begin Transaction
         lRet :=FWFormCommit(oModel)
         End Transaction
      endif

    endif
Return lRet
//2 - Função Principal
Static Function Valida(nOperation,nRecAtual,cDesc, cAlbCod,cCod)
    Local lExist := .F.
    Local aArea  := ZZM->(GetArea())

    ZZM->(dbSetOrder(2))
    if ZZM->(dbSeek(xFilial("ZZM")+cDesc+cAlbCod)) //Validação de mesmo titulo com o mesmo codigo de cantor
      if nOperation==MODEL_OPERATION_INSERT .or. (ZZM->(Recno())!=nRecAtual)
       lExist := .T.
      endif
    endif
Return lExist

Static Function ShowError(oModel)
    oModel:setErrorMessage(,,, , ,;
        "Duplicidade Detectada",;
        "Este registro (Título/Álbum ou Código) já existe no sistema.",;
        "Por favor, verifique os dados antes de salvar.", , , )
Return .F.
