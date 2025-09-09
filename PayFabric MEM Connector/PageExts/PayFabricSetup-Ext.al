pageextension 70100 "PayFabric Setup Ext" extends nodePaySettings
{
    layout
    {
        // Add changes to page layout here
        addlast("Preferences Section")
        {
            field("MEM Company Code"; Rec."MEM Company Code")
            {
                Caption = 'Company Code';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    var
        DimmensionValues: Record "Dimension Value";
        PFSetup: Record nodePaySettings;
    begin
        Clear(PFSetup);
        PFSetup.Init();
        if PFSetup.FindFirst() then begin
            if PFSetup."MEM Company Code" = '' then begin
                Clear(DimmensionValues);
                DimmensionValues.SetRange(Blocked, false);
                DimmensionValues.SetRange("Global Dimension No.", 1);
                if DimmensionValues.FindFirst() then begin
                    PFSetup."MEM Company Code" := DimmensionValues.Code;
                    PFSetup.Modify();
                end;
            end;
        end;
    end;
}