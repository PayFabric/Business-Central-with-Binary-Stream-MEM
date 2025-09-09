codeunit 70100 "PF And MEM Integration"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;

    /// <summary>
    /// On Before Posting Sales Documents
    /// </summary>
    /// <param name="GenJournalLine"></param>
    /// <param name="SalesInvHeader"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::nodPayFabricIntegration, OnBeforeInsertGenJournalLineWhenPost, '', true, true)]
    local procedure OnBeforeInsertGenJournalLineWhenPost(var GenJournalLine: Record "Gen. Journal Line"; SalesInvHeader: Record "Sales Invoice Header")
    begin
        if SalesInvHeader."Shortcut Dimension 1 Code" <> '' then
            GenJournalLine.BssiEntityID := SalesInvHeader."Shortcut Dimension 1 Code";
    end;

    /// <summary>
    /// On before clicking PayFabric 'Record Payment' action
    /// </summary>
    /// <param name="GenJournalLine"></param>
    /// <param name="SalesHeaderRec"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::nodPayFabricIntegration, OnBeforeInsertGenJournalLineWhenRecordPayment, '', true, true)]
    local procedure OnBeforeInsertGenJournalLineWhenRecordPayment(var GenJournalLine: Record "Gen. Journal Line"; SalesHeaderRec: Record "Sales Header")
    begin
        if SalesHeaderRec."Shortcut Dimension 1 Code" <> '' then
            GenJournalLine.BssiEntityID := SalesHeaderRec."Shortcut Dimension 1 Code";
    end;

    /// <summary>
    /// On before posting sales return order
    /// </summary>
    /// <param name="GenJournalLine"></param>
    /// <param name="SalesCMHeader"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::nodPayFabricEventSub, OnBeforeInsertGenJournalLineWhenPostReturnOrder, '', true, true)]
    local procedure OnBeforeInsertGenJournalLineWhenPostReturnOrder(var GenJournalLine: Record "Gen. Journal Line"; SalesCMHeader: Record "Sales Cr.Memo Header")
    begin
        if SalesCMHeader."Shortcut Dimension 1 Code" <> '' then
            GenJournalLine.BssiEntityID := SalesCMHeader."Shortcut Dimension 1 Code";
    end;

    /// <summary>
    /// On before adding surcharge invoice on cash receipt journals
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::nodPayFabricIntegration, OnBeforeInsertGenJournalLineWhenAddSurchargeInvoice, '', true, true)]
    local procedure OnBeforeInsertGenJournalLineWhenAddSurchargeInvoice(var GenJournalLine: Record "Gen. Journal Line"; "Shortcut Dimension 1 Code": Code[20])
    begin
        if "Shortcut Dimension 1 Code" <> '' then
            GenJournalLine.BssiEntityID := "Shortcut Dimension 1 Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::nodePayIntegration, OnBeforeInsertGenJournalLineWhenIntegratePFRPayment, '', true, true)]
    local procedure OnBeforeInsertGenJournalLineWhenIntegratePFRPayment(var GenJournalLine: Record "Gen. Journal Line")
    begin
        if (GenJournalLine."Applies-to Doc. No." <> '') or (GenJournalLine."Nod Applies-to Future Inv No." <> '') then
            if GenJournalLine."Shortcut Dimension 1 Code" <> '' then begin
                GenJournalLine.BssiEntityID := GenJournalLine."Shortcut Dimension 1 Code";
                exit;
            end;
        GenJournalLine.BssiEntityID := GetMEMCompanyCode();
        GenJournalLine."Shortcut Dimension 1 Code" := GetMEMCompanyCode();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::nodePayIntegration, OnBeforeInsertGenJournalLineWhenIntegratePFRSurcharge, '', true, true)]
    local procedure OnBeforeInsertGenJournalLineWhenIntegratePFRSurcharge(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine.BssiEntityID := GetMEMCompanyCode();
        GenJournalLine."Shortcut Dimension 1 Code" := GetMEMCompanyCode();
    end;


    local procedure GetMEMCompanyCode(): Code[50]
    var
        PayFabricSetupRec: Record nodePaySettings;
        DimensionValues: Record "Dimension Value";
    begin
        Clear(PayFabricSetupRec);
        if PayFabricSetupRec.FindFirst() then begin
            if PayFabricSetupRec."MEM Company Code" <> '' then
                exit(PayFabricSetupRec."MEM Company Code");
            Clear(DimensionValues);
            DimensionValues.SetRange("Global Dimension No.", 1);
            DimensionValues.SetRange(Blocked, false);
            if DimensionValues.FindFirst() then
                exit(DimensionValues.Code);
        end;
    end;
}