function PlotCosts(pop,rep)

%     pop_costs=[pop.Cost];
%     plot(18.1*pop_costs(1,:)+703.1,pop_costs(2,:)*3.42+45.29,'k.','markersize',2);
%     
%     hold on;
    
    rep_costs=[rep.Cost];
    plot(rep_costs(1,:),-rep_costs(2,:),'k+','markersize',8);
    
    xlabel('LOS');
    ylabel('nPatients');
    
    %grid on;
    
    hold off;

end