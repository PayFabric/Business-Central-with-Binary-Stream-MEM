tableextension 70100 "PayFabric Setup Ext" extends nodePaySettings
{
    fields
    {
        // Add changes to table fields here
        field(70100; "MEM Company Code"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}