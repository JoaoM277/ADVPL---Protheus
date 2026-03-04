#Include "totvs.ch"
#Include "fwmvcdef.ch"


Static cTitulo := "Cadastro de Albuns"

User Function ALBUNS()
    local aArea   := GetArea()
    local oBrowse

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZZA")
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()
       
    RestArea(aArea)

return Nil
	
//MenuDef
Static Function MenuDef()
   Local aRotina := {} //Variavel de Rotina

   //Opções do Menu, Ex:
    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.ALBUNS" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.ALBUNS" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.ALBUNS" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.ALBUNS" OPERATION 5 ACCESS 0
Return aRotina

//ModelDef
Static Function ModelDef()
  //Local oStruct := FWFormStruct(1, cAliasMVC)
  Local oModel := Nil
  Local oStpai := FWFormStruct(1, 'ZZA')
  Local oStFilho := FWFormStruct(1, 'ZZM')
  Local aZZMRel := {}

  //Definição de Campos
  //oObj:GetModel("SB1MASTER"):GetStruct():SetProperty("B1_COD", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN , ".F."))
  oStpai: GetModel("ZZAMASTER"):GetStruct():SetProperty('ZZA_CD', MODEL_FIELD_VIEW, FwBuildFeature(STRUCT_FEATURE_WHEN, ".F."))
  oStpai: SetProperty('ZZA_CD', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'GetSXENum("ZZA","ZZA_CD")'))
  oStpai: SetProperty('ZZA_ARTCOD', MODEL_FIELD_VALID, FwBuildFeature(STRUCT_FEATURE_VALID, 'ExistCpo("ZZC", M->ZZA_ARTCOD)'))
  oStFilho: SetProperty('ZZM_ALBCOD', MODEL_FIELD_VIEW, FwBuildFeature(STRUCT_FEATURE_WHEN, ".F."))
  oStFilho: SetProperty('ZZM_ALBCOD', MODEL_FIELD_OBRIGAT, .F.)
  oStFilho: SetProperty('ZZM_ALBCOD', MODEL_FIELD_OBRIGAT, .F.)
  oStFilho: SetProperty('ZZM_COD', MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD, 'u_zFCOD'))

  //Relacionamentos
  oModel := MPFormModel():New(ALBUNS)
  oModel:AddField('ZZAMASTER',/*cOwner*/,oStpai)
  oModel:AddGrid('ZZMDETAIL','ZZAMASTER',oStFilho,/*bLinePre*/,/*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do Modelo*/)

  //Fazendo Relacionamento Pai e filho
  aAdd(aZZMRel, ('ZZM_FILIAL','ZZA_FILIAL'))
  aAdd(aZZMRel, ('ZZM_ARTCOD','ZZA_ARTCOD'))
  aAdd(aZZMRel, ('ZZM_ALBCOD','ZZA_CD'))


  oModel:SetRelation('ZZMDETAIL', aZZMRel, ZZM ->(IndexKey(1)))
  oModel:GetModel('ZZMDETAIL'):SetUniquieLine(('ZZM_DESC'))
  oModel:SetPrimaryKey({})

  //Descrição
  oModel:SetDescription("Cadastro de Musicas")
  oModel:GetModel('ZZAMASTER'):SetDescription("Album")
  oModel:GetModel('ZZMDETAIL'):SetDescription("Faixas")
  
Return oModel

//ViewDef
Static Function ViewDef() 
  Local oView := Nil
  Local oModel := FWLoadModel('ALBUNS')
  Local oStpai := FWFormStruct(2, 'ZZA')
  Local oStFilho := FWFormStruct(2, 'ZZM')

    //Cria a visualização do cadastro
    oView := FWFormVView():New()
    oView:SetModel(oModel)

    //Cabeçalho
    oView:AddField('VIEW_ZZA', oStpai, 'ZZAMASTER')
    oView:AddGrid('VIEW_ZZM', oStFilho, 'ZZMDETAIL')

    //Dimensionamento de Tabelas
    oView:CreateHorizontalBox('CABEC',30)
    oView:CreateHorizontalBox('GRID',70)

    //Amarrando a view com as Box
    oView:SetOwnerView('VIEW_ZZA','CABEC')
    oView:SetOwnerView('VIEW_ZZM','GRID')

    //Setando Titulos
    oView:EnableTitleView('VIEW_ZZA',"Cadastro de Albuns")
    oView:EnableTitleView('VIEW_ZZM',"Faixas Musicais")

    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})

    //Remove os Campos que não devem ser vistos
    oStFilho:RemoveField('ZZM_ARTCOD')
    oStFilho:RemoveField('ZZM_ALBCOD')

Return oView

User Function u_zFCOD()
    Local aArea := GetArea()
    //Local oCod := StrTran(Space(TamSX3('ZZM_COD'),{1}),'','0')
    //Local oModelPad := oModelPad:GetModel("ZZMDETAIL")
    //Local nOperacao := oModelPad:nOperation
    Local nLineAtu := oModelGrid:nLine
    Local nPosCod := aSoam(oModelGrid:aHeader, {|x| AllTrim(x[2]) == AllTrim("ZZM_COD")})
    
    If nLineAtu < 1
       oCod := Soma1(oCod)
    else
        oCod := oModelGrid:aCols(nLineAtu)[nPosCod]
        oCod := Soma1(oCod)
    Endif

    RestArea(aArea)
Return oCod
