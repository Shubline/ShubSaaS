interface Window {

    // Generic options
    SetOption(key: string, value: any): void;

    // AL Button Group
    AddButton(caption: string, title: string, id: string, type: string): void;
    RemoveButton(id: string): void;

    // ChangeCompany Dropdown
    SetCompany(name: string, title: string): void;
    SetCurrentCompany(name: string): void;
}



interface CompanyOption {
    Name: string;
    Title: string;
}
