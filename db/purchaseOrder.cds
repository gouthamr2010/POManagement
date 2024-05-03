using {
    managed,
    cuid
} from '@sap/cds/common';

using {com.gr.common} from './common';
using {com.gr.MD as MD} from './masterData';

namespace com.gr.PurchaseOrder;

entity Headers : managed, cuid, common.Amount {
    @cascade: {all}
    item                         : Composition of many Items
                                       on item.poHeader = $self;
    noteId                       : common.BusinessKey null;
    //    partner                      : UUID;
    partner                      : Association to one MD.BusinessPartners;
    lifecycleStatus              : common.StatusT default 'N';
    approvalStatus               : common.StatusT;
    confirmStatus                : common.StatusT;
    orderingStatus               : common.StatusT;
    invoicingStatus              : common.StatusT;
    @readonly createdByEmployee  : Association to one MD.Employees
                                       on createdByEmployee.email = createdBy;
    @readonly modifiedByEmployee : Association to one MD.Employees
                                       on modifiedByEmployee.email = modifiedBy;
}

annotate Headers with @(
    title      : '{i18n>poService}',
    description: '{i18n>poService}'
) {
    ID              @(
        title      : '{i18n>po_id}',
        description: '{i18n>po_id}',
    );

    item            @(
        title      : '{i18n>po_items}',
        description: '{i18n>po_items}',
    );

    noteId          @(
        title      : '{i18n>notes}',
        description: '{i18n>notes}'
    );

    partner         @(
        title           : '{i18n>partner_id}',
        description     : '{i18n>partner_id}',
        Common.ValueList: {
            CollectionPath: 'BusinessPartners',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: 'partner_ID',
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'companyName'
                }
            ]
        }
    );

    lifecycleStatus @(
        title              : '{i18n>lifecycle}',
        description        : '{i18n>lifecycle}',
        Common.FieldControl: #ReadOnly
    );

    approvalStatus  @(
        title              : '{i18n>approval}',
        description        : '{i18n>approval}',
        Common.FieldControl: #ReadOnly
    );

    confirmStatus   @(
        title              : '{i18n>confirmation}',
        description        : '{i18n>confirmation}',
        Common.FieldControl: #ReadOnly
    );

    orderingStatus  @(
        title              : '{i18n>ordering}',
        description        : '{i18n>ordering}',
        Common.FieldControl: #ReadOnly
    );

    invoicingStatus @(
        title              : '{i18n>invoicing}',
        description        : '{i18n>invoicing}',
        Common.FieldControl: #ReadOnly
    );

};

entity Items : cuid, common.Amount, common.Quantity {
    poHeader     : Association to Headers;
    product      : Association to MD.Products;
    noteId       : common.BusinessKey null;
    deliveryDate : common.SDate;
}

annotate Items with {
    ID           @(
        title      : '{i18n>internal_id}',
        description: '{i18n>internal_id}',
    );

    product      @(
        title              : '{i18n>product}',
        description        : '{i18n>product}',
        Common.FieldControl: #Mandatory,
        Search.defaultSearchElement,
        Common.ValueList   : {
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: 'product_productId',
                    ValueListProperty: 'productId'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'category'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                }
            ]
        }
    );

    deliveryDate @(
        title      : '{i18n>deliveryDate}',
        description: '{i18n>deliveryDate}'
    )
}
