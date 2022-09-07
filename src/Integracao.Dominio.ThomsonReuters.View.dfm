object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Integra'#231#227'o Dom'#237'nio Sistemas - Thomsom Reuters'
  ClientHeight = 461
  ClientWidth = 799
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 799
    Height = 187
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    object botaoAutenticar: TButton
      Left = 584
      Top = 33
      Width = 193
      Height = 24
      Caption = 'Autenticar '
      Enabled = False
      TabOrder = 0
      OnClick = botaoAutenticarClick
    end
    object ClientId: TLabeledEdit
      Left = 24
      Top = 25
      Width = 513
      Height = 24
      EditLabel.Width = 54
      EditLabel.Height = 16
      EditLabel.Caption = 'Client ID'
      TabOrder = 1
      OnChange = ClientIdChange
    end
    object SecretKey: TLabeledEdit
      Left = 24
      Top = 77
      Width = 513
      Height = 24
      EditLabel.Width = 71
      EditLabel.Height = 16
      EditLabel.Caption = 'Secret Key'
      TabOrder = 2
      OnChange = SecretKeyChange
    end
    object botaoConfirmarIntegrationKey: TButton
      Left = 584
      Top = 63
      Width = 193
      Height = 24
      Hint = 
        'Confirmar a Key do Cliente'#13#10'O contador do cliente do sistema ir'#225 +
        ' fornecer a Key dos seus clientes que emitem a nota no ERP integ' +
        'rado, '#13#10'onde '#233' necess'#225'rio antes de gerar a Integration Key, conf' +
        'irmar se essa Key '#233' realmente do cliente que est'#225' fazendo a inte' +
        'gra'#231#227'o.'
      Caption = 'Confirmar Cliente'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      WordWrap = True
      OnClick = botaoConfirmarIntegrationKeyClick
    end
    object IntegrationKey: TLabeledEdit
      Left = 24
      Top = 129
      Width = 513
      Height = 24
      EditLabel.Width = 162
      EditLabel.Height = 16
      EditLabel.Caption = 'Integration Key (Cliente)'
      TabOrder = 4
    end
    object botaoGerarKeyIntegracao: TButton
      Left = 584
      Top = 93
      Width = 193
      Height = 24
      Caption = 'Gerar Key Integra'#231#227'o'
      Enabled = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 5
      WordWrap = True
      OnClick = botaoGerarKeyIntegracaoClick
    end
    object CheckBoxSalvarCredenciais: TCheckBox
      Left = 608
      Top = 10
      Width = 145
      Height = 17
      Caption = 'Salvar Cred'#234'nciais'
      Enabled = False
      TabOrder = 6
    end
    object botaoEnviarArquivo: TButton
      Left = 584
      Top = 123
      Width = 193
      Height = 24
      Caption = 'Enviar XML'
      Enabled = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 7
      WordWrap = True
      OnClick = botaoEnviarArquivoClick
    end
    object botaoConsultarEnvioXML: TButton
      Left = 584
      Top = 153
      Width = 193
      Height = 24
      Caption = 'Consultar Envio do XML'
      Enabled = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 8
      WordWrap = True
      OnClick = botaoConsultarEnvioXMLClick
    end
  end
  object PageControlData: TPageControl
    Left = 0
    Top = 187
    Width = 799
    Height = 274
    ActivePage = TabSheetConsultarEnvioXML
    Align = alClient
    TabOrder = 1
    object TabSheetHome: TTabSheet
      Caption = 'Home'
      ExplicitHeight = 252
      object panelHome: TPanel
        Left = 0
        Top = 0
        Width = 791
        Height = 246
        Align = alClient
        Caption = 'Autentica'#231#227'o API Dom'#237'nio Sistemas - Thomson Reuters'
        Color = 16758363
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 252
        object LabelUrlDoc: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 31
          Width = 783
          Height = 19
          Cursor = crHandPoint
          Margins.Top = 30
          Align = alTop
          Alignment = taCenter
          Caption = 
            'https://suporte.dominioatendimento.com:82/central/faces/solucao.' +
            'html?codigo=8476'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          OnMouseEnter = LabelUrlDocMouseEnter
          OnMouseLeave = LabelUrlDocMouseLeave
          ExplicitTop = 4
          ExplicitWidth = 710
        end
      end
    end
    object TabSheetToken: TTabSheet
      Caption = 'Token'
      ExplicitHeight = 252
      object MemoToken: TMemo
        Left = 0
        Top = 0
        Width = 791
        Height = 246
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitHeight = 252
      end
    end
    object TabSheetConfirmacaoCliente: TTabSheet
      Caption = 'Confirma'#231#227'o Cliente'
      ImageIndex = 1
      ExplicitHeight = 252
      object MemoConfirmacaoCliente: TMemo
        Left = 0
        Top = 0
        Width = 791
        Height = 246
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitHeight = 252
      end
    end
    object TabSheetKeyIntegracao: TTabSheet
      Caption = 'Key Integra'#231#227'o'
      ImageIndex = 3
      ExplicitHeight = 252
      object MemoKeyIntegracao: TMemo
        Left = 0
        Top = 0
        Width = 791
        Height = 246
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitHeight = 252
      end
    end
    object TabSheetEnvioXML: TTabSheet
      Caption = 'Envio XML'
      ImageIndex = 4
      ExplicitHeight = 264
      object GridPanel: TGridPanel
        Left = 0
        Top = 0
        Width = 791
        Height = 246
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = Panel2
            Row = 0
          end
          item
            Column = 0
            Control = Panel3
            Row = 1
          end>
        RowCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ShowCaption = False
        TabOrder = 0
        ExplicitLeft = 304
        ExplicitTop = 112
        ExplicitWidth = 185
        ExplicitHeight = 41
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 791
          Height = 123
          Align = alClient
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          ExplicitLeft = 304
          ExplicitTop = 112
          ExplicitWidth = 185
          ExplicitHeight = 41
          object LabelArquivoXML: TLabel
            Left = 0
            Top = 0
            Width = 791
            Height = 16
            Align = alTop
            Alignment = taCenter
            Caption = 'LabelArquivoXML'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ExplicitWidth = 97
          end
          object MemoArquivoXML: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 19
            Width = 785
            Height = 101
            Align = alClient
            ReadOnly = True
            TabOrder = 0
            ExplicitLeft = 0
            ExplicitTop = 32
            ExplicitWidth = 791
            ExplicitHeight = 153
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 123
          Width = 791
          Height = 123
          Align = alClient
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 1
          ExplicitLeft = 304
          ExplicitTop = 112
          ExplicitWidth = 185
          ExplicitHeight = 41
          object Label1: TLabel
            Left = 0
            Top = 0
            Width = 791
            Height = 16
            Align = alTop
            Alignment = taCenter
            Caption = 'Resposta envio'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ExplicitWidth = 86
          end
          object MemoRespostaProcessamento: TMemo
            AlignWithMargins = True
            Left = 3
            Top = 19
            Width = 785
            Height = 101
            Align = alClient
            ReadOnly = True
            TabOrder = 0
            ExplicitLeft = 0
            ExplicitTop = 16
            ExplicitWidth = 791
            ExplicitHeight = 116
          end
        end
      end
    end
    object TabSheetConsultarEnvioXML: TTabSheet
      Caption = 'TabSheetConsultarEnvioXML'
      ImageIndex = 5
      object MemoConsultarEnvioXML: TMemo
        Left = 0
        Top = 0
        Width = 791
        Height = 246
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitHeight = 252
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Arquivo XML|*.XML'
    Left = 552
    Top = 88
  end
end
