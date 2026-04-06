%%Create Variables
D1 = 9;
D2 = 2;
D3 = 9;
D4 = 5;
D5 = 17;
D6 = 0.5;
D7 = 34.5;
W1 = 0.8;
W2 = 0.5;
W3 = 1;
L1 = 5.5;
L2 = 5.5;
L3 = W1+D4+W2+D5;
PCBwidth = D7+L1-D6+W3+D2;
PCBlength = D1+L3+D3;
CopperToEdgeClearance = 0.5;

%%Create pcbStack object
pcbobj = pcbStack;

%%Create board shape
    %Creating BoardShape metal layer.
        %Creating PCB shape.
        PCB = antenna.Rectangle;
        PCB.Name = "PCB";
        PCB.Center = ([PCBlength/2,PCBwidth/2-D7]).*0.001;
        PCB.Length = (PCBlength).*0.001;
        PCB.Width = (PCBwidth).*0.001;
        PCB = rotate(PCB,0,[PCB.Center,-1],[PCB.Center,1]);
    BoardShape = PCB;
pcbobj.BoardShape = BoardShape;

%%Create Stackup
    %Creating F_Cu metal layer.
        %Creating IFA shape.
        IFA = antenna.Rectangle;
        IFA.Name = "IFA";
        IFA.Center = ([W1/2+D1,L1/2-D6]).*0.001;
        IFA.Length = (W1).*0.001;
        IFA.Width = (L1).*0.001;
        IFA = rotate(IFA,0,[IFA.Center,-1],[IFA.Center,1]);
            %Creating Rectangle3 shape.
            Rectangle3 = antenna.Rectangle;
            Rectangle3.Name = "Rectangle3";
            Rectangle3.Center = ([D1+L3/2,L1-D6+W3/2]).*0.001;
            Rectangle3.Length = (L3).*0.001;
            Rectangle3.Width = (W3).*0.001;
            Rectangle3 = rotate(Rectangle3,0,[Rectangle3.Center,-1],[Rectangle3.Center,1]);
        IFA = IFA + Rectangle3;%Add
            %Creating Rectangle4 shape.
            Rectangle4 = antenna.Rectangle;
            Rectangle4.Name = "Rectangle4";
            Rectangle4.Center = ([D1+W1+D4+W2/2,L1-D6-L2/2]).*0.001;
            Rectangle4.Length = (W2).*0.001;
            Rectangle4.Width = (L2).*0.001;
            Rectangle4 = rotate(Rectangle4,0,[Rectangle4.Center,-1],[Rectangle4.Center,1]);
        IFA = IFA + Rectangle4;%Add
    F_Cu = IFA;
    %Creating DielectricLayer1 dielectric layer.
    DielectricLayer1 = dielectric("Name",'Custom',"EpsilonR",4.4,"LossTangent",0.026,"Thickness",0.0002104);
    %Creating In1_Cu metal layer.
        %Creating GND shape.
        GND = antenna.Rectangle;
        GND.Name = "GND";
        GND.Center = ([PCBlength/2,-D7/2+CopperToEdgeClearance/2]).*0.001;
        GND.Length = (PCBlength-2*CopperToEdgeClearance).*0.001;
        GND.Width = (D7-CopperToEdgeClearance).*0.001;
        GND = rotate(GND,0,[GND.Center,-1],[GND.Center,1]);
    In1_Cu = GND;
    %Creating DielectricLayer2 dielectric layer.
    DielectricLayer2 = dielectric("Name",'Custom',"EpsilonR",4.6,"LossTangent",0.026,"Thickness",0.001065);
    %Creating In2_Cu metal layer.
        %Creating GND shape.
        GND = antenna.Rectangle;
        GND.Name = "GND";
        GND.Center = ([PCBlength/2,-D7/2+CopperToEdgeClearance/2]).*0.001;
        GND.Length = (PCBlength-2*CopperToEdgeClearance).*0.001;
        GND.Width = (D7-CopperToEdgeClearance).*0.001;
        GND = rotate(GND,0,[GND.Center,-1],[GND.Center,1]);
    In2_Cu = GND;
    %Creating DielectricLayer3 dielectric layer.
    DielectricLayer3 = dielectric("Name",'Custom',"EpsilonR",4.4,"LossTangent",0.026,"Thickness",0.0002104);

%%Create Feed
feedloc = [[D1+W1+D4+W2/2,L1-D6-L2+(W2/2)].*0.001,[1 3];...
    ];

%%Create Via
vialoc = [[(D1+W1/2)-5,-(D6/2)-5].*0.001,[3 5];...
[(D1+W1/2),-(D6/2)-5].*0.001,[3 5];...
[(D1+W1/2),-(D6/2)-10].*0.001,[3 5];...
[(D1+W1/2)+5,-(D6/2)-5].*0.001,[3 5];...
[(D1+W1/2)-5,-(D6/2)-10].*0.001,[3 5];...
[(D1+W1/2)+5,-(D6/2)-10].*0.001,[3 5];...
[D1+W1/2,-D6/2].*0.001,[1 3]
    ];

%%Create Metal
metalobj = metal;
metalobj.Name = 'Copper';
metalobj.Conductivity = 59600000;
metalobj.Thickness = 0.000889; % 0.035 mils

pcbobj.Conductor = metalobj;

%%Assign properties
pcbobj.BoardThickness = 0.0014858;
pcbobj.Layers = {F_Cu,DielectricLayer1,In1_Cu,DielectricLayer2,In2_Cu,DielectricLayer3,};
pcbobj.FeedLocations = feedloc;
pcbobj.FeedDiameter = 0.0005;
pcbobj.ViaLocations = vialoc;
pcbobj.ViaDiameter = 0.0003;
pcbobj.FeedViaModel = 'square';
pcbobj.FeedVoltage = 1;
pcbobj.FeedPhase = 0;
