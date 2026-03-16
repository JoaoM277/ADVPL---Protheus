#Include "totvs.ch"
#Include "fwmvcdef.ch"


Static cAliasMVC := "ZZV"
Static cTitulo := "Produtos"

User Function PRODUTO()
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

	//Opções do Menu, Ex: MVC
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.PRODUTO" OPERATION MODEL_OPERATION_VIEW ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.PRODUTO" OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.PRODUTO" OPERATION  MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.PRODUTO" OPERATION MODEL_OPERATION_DELETE ACCESS 0
Return aRotina

//ModelDef
Static Function ModelDef()
	Local oStruct := FWFormStruct(1, cAliasMVC)
	Local oModel
	Local bPre := Nil
	Local bPos := {|oModel, lCommit| fValidaPr(oModel)}
	Local bCommit := Nil
	Local bCancel := Nil

	

	//Cria o modelo de dados para o cadastro
	oModel := MPFormModel():New("MODELMVC", bPre, bPos, bCommit, bCancel) // Aqui coloquei outro nome para nao dar algum tipo de conflito com a função
	oModel :AddFields("MASTER", /*cOwner*/, oStruct) // Aqui coloquei "MASTER" os dev usa assim nos codigos
	oModel :SetDescription("Modelo de dados - " + cTitulo)
	oModel :GetModel("MASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel :SetPrimaryKey({"ZZV_COD"})

Return oModel

//ViewDef
Static Function ViewDef()
	Local oModel := FWLoadModel("PRODUTO")
	Local oStruct := FWFormStruct(2, cAliasMVC)
	Local oView

	//Cria a visualização do cadastro
	oView := FWFormView():New()
	oView :SetModel(oModel)
	oView :AddField("VIEW_PRODUTO", oStruct, "MASTER")
	oView :CreateHorizontalBox("TELA" , 100)
	oView :SetOwnerView("VIEW_PRODUTO", "TELA")

Return oView

//Função de preço minimo, validação de duplicidade e msg de erro
Static Function fValidaPr(oModel)

	Local nPrice := oModel:GetValue("MASTER","ZZV_PRE")
	Local nOperation := oModel:GetOperation()
	Local nMinPrice  := 5.00
	Local lRet       := .T.
	Local nRecAtual  := ZZV->(Recno())
	Local cDesc      := oModel:GetValue("MASTER","ZZV_PROD")
	Local lExist     := .F.

	If nOperation == MODEL_OPERATION_INSERT .or. nOperation == MODEL_OPERATION_UPDATE
		If nPrice < nMinPrice
			oMOdel:SetErrorMessage("MASTER","ZZV_PRE","PRE_INV","Preço Invalido","Preço minimo abaixo do padrão","Coloque um preço maior ou igual a R$ 5,00")
			lRet := .F.
		endif

		If nOperation == MODEL_OPERATION_UPDATE
			If !MsgYesNo("Tem certeza que deseja alterar o registro atual?",    "Confirmação")
				Return .F.
			EndIf
		EndIf

        ZZV->(dbSetOrder(1))
		if ZZV->(dbSeek(xFilial("ZZV")+cDesc))
		    if nOperation==MODEL_OPERATION_INSERT .or. (ZZV->(Recno())  !=nRecAtual)
             lExist := .T.
			endif
       endif

	    if lExist := .T.
		 oModel:setErrorMessage(,,, , ,;
         "Duplicidade Detectada",;
         "Este registro (Título/Álbum ou Código) já existe no sistema.",;
         "Por favor, verifique os dados antes de salvar.", , , )
		 lRet := .F.
		endif

	Endif

Return lRet

