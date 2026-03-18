import React, { useState } from "react";
import {
  Home,
  Settings,
  FlaskConical,
  Bot,
  Package,
  Shield,
  GitCompare,
  FileText,
} from "lucide-react";
 
type Screen =
  | "home"
  | "ingestion"
  | "extraction"
  | "assistant"
  | "portal"
  | "regulatory"
  | "comparison"
  | "generator";
 
export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>("home");
 
  const metrics = {
    documentsIngested: 324,
    ingestionBacklog: 12,
    extractionSuccessRate: 94,
    assistantAnswers: 512,
    portalDownloads: 276,
    complianceScore: 92,
    comparisonsRun: 74,
    contentGenerated: 43,
  };
 
  const navItems = [
    { key: "home", icon: Home },
    { key: "ingestion", icon: Settings },
    { key: "extraction", icon: FlaskConical },
    { key: "assistant", icon: Bot },
    { key: "portal", icon: Package },
    { key: "regulatory", icon: Shield },
    { key: "comparison", icon: GitCompare },
    { key: "generator", icon: FileText },
  ];
 
  return (
    <div className="flex h-screen bg-white text-slate-900">
 
      {/* SIDEBAR */}
      <aside className="w-20 border-r border-slate-200 flex flex-col items-center py-4">
        <div className="w-12 h-12 mb-6 rounded-lg overflow-hidden border bg-white flex items-center justify-center">
          <img src="/logo.jpg" className="max-w-full max-h-full object-contain" />
        </div>
 
        <div className="flex flex-col gap-4">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <button
                key={item.key}
                onClick={() => setCurrentScreen(item.key as Screen)}
                className={`w-12 h-12 rounded-full flex items-center justify-center
                ${
                  currentScreen === item.key
                    ? "bg-yellow-300"
                    : "hover:bg-yellow-200"
                }`}
              >
                <Icon size={18} strokeWidth={2.5} />
              </button>
            );
          })}
        </div>
      </aside>
 
      {/* MAIN */}
      <div className="flex-1 overflow-y-auto p-6 bg-slate-50">
        {currentScreen === "home" && (
          <HomeDashboard
            metrics={metrics}
            setCurrentScreen={setCurrentScreen}
          />
        )}
        {currentScreen !== "home" && (
          <Placeholder title={currentScreen} />
        )}
      </div>
    </div>
  );
}
 
/* ---------------- HOME ---------------- */
 
const HomeDashboard = ({ metrics, setCurrentScreen }: any) => {
  const lineData = [42, 48, 56, 60, 58, 64, 72, 76, 80, 88, 96, 100];
  const max = Math.max(...lineData);
 
  const dist = [
    { label: "SDS", value: 142, color: "bg-blue-900" },
    { label: "TDS", value: 106, color: "bg-yellow-400" },
    { label: "Spec", value: 76, color: "bg-teal-700" },
  ];
 
  const links = [
    { label: "Ingestion", key: "ingestion" },
    { label: "Extraction", key: "extraction" },
    { label: "Assistant", key: "assistant" },
    { label: "Portal", key: "portal" },
    { label: "Regulatory", key: "regulatory" },
    { label: "Comparison", key: "comparison" },
    { label: "Generator", key: "generator" },
  ];
 
  return (
    <div className="space-y-6">
 
      <Header title="ChemOps Intelligence" />
      <div className="text-slate-500 text-sm -mt-4">Overview of platform activity</div>
 
      {/* METRICS */}
      <div className="grid grid-cols-4 gap-4">
        <MetricCard title="Documents Ingested" value={metrics.documentsIngested} trend="+12% MoM" />
        <MetricCard title="Extraction Success" value={`${metrics.extractionSuccessRate}%`} trend="+3 pts" />
        <MetricCard title="Assistant Answers" value={metrics.assistantAnswers} trend="+18 this week" />
        <MetricCard title="Compliance Score" value={`${metrics.complianceScore}%`} trend="Stable" />
      </div>
 
      {/* CHARTS */}
      <div className="grid grid-cols-3 gap-6">
 
        {/* Throughput */}
        <Card title="Throughput">
          <div className="flex justify-between text-sm text-slate-500 mb-2">
            <span>Document Throughput</span>
            <span className="text-xs text-slate-400">Ingestion</span>
          </div>
 
          <div className="flex items-end gap-2 h-32">
            {lineData.map((v, i) => (
              <div
                key={i}
                style={{ height: `${(v / max) * 100}%` }}
                className="flex-1 bg-yellow-400 rounded"
              />
            ))}
          </div>
 
          <div className="text-xs text-slate-400 mt-2">
            Steady growth in weekly ingestion volume
          </div>
        </Card>
 
        {/* Distribution */}
        <Card title="File Type Distribution">
          <div className="flex h-4 rounded overflow-hidden">
            {dist.map((d, i) => (
              <div
                key={i}
                style={{ width: `${(d.value / 324) * 100}%` }}
                className={d.color}
              />
            ))}
          </div>
 
          <div className="mt-4 space-y-2 text-sm">
            {dist.map((d) => (
              <div key={d.label} className="flex items-center gap-2">
                <span className={`w-2 h-2 rounded-full ${d.color}`} />
                <span>{d.label}</span>
                <span className="ml-auto text-slate-500">{d.value}</span>
              </div>
            ))}
          </div>
        </Card>
 
        {/* Heatmap */}
        <Card title="Portfolio Risk Heatmap">
          <div className="flex justify-between text-sm text-slate-500 mb-2">
            <span>Risk Overview</span>
            <span className="text-xs text-slate-400">Regulatory</span>
          </div>
 
          <div className="grid grid-cols-6 gap-2">
            {[...Array(18)].map((_, i) => {
              const val = (i * 7 + 13) % 100;
 
              const color =
                val > 75
                  ? "bg-teal-700"
                  : val > 50
                  ? "bg-yellow-400"
                  : val > 25
                  ? "bg-blue-900"
                  : "bg-slate-500";
 
              return <div key={i} className={`h-6 rounded ${color}`} />;
            })}
          </div>
 
          <div className="text-xs text-slate-400 mt-2">
            Hotspots indicate higher regulatory attention
          </div>
        </Card>
      </div>
 
      {/* LOWER */}
      <div className="grid grid-cols-2 gap-6 items-stretch">
 
        <Card title="At a Glance">
          <div className="grid grid-cols-2 gap-4">
            <TinyStat label="Backlog" value={metrics.ingestionBacklog} />
            <TinyStat label="Comparisons" value={metrics.comparisonsRun} />
            <TinyStat label="Downloads" value={metrics.portalDownloads} />
            <TinyStat label="Generated" value={metrics.contentGenerated} />
          </div>
        </Card>
 
        <Card title="Quick Links">
          <div className="grid grid-cols-3 gap-3">
            {links.map((l) => (
              <div
                key={l.key}
                onClick={() => setCurrentScreen(l.key)}
                className="cursor-pointer p-3 border rounded-lg hover:bg-yellow-100 transition"
              >
                <div className="text-sm font-medium">{l.label}</div>
              </div>
            ))}
          </div>
        </Card>
 
      </div>
    </div>
  );
};
 
/* ---------------- COMPONENTS ---------------- */
 
const Header = ({ title }: any) => (
  <div className="flex items-center gap-3">
    <h2 className="text-2xl font-semibold">{title}</h2>
    <div className="flex gap-2">
      <div className="w-4 h-4 bg-yellow-400" />
      <div className="w-4 h-4 bg-yellow-400" />
      <div className="w-4 h-4 bg-yellow-400" />
    </div>
  </div>
);
 
const Card = ({ title, children }: any) => (
  <div className="bg-white p-5 rounded-xl border h-full">
    <h3 className="font-semibold mb-3">{title}</h3>
    {children}
  </div>
);
 
const MetricCard = ({ title, value, trend }: any) => {
  const color =
    trend?.includes("+")
      ? "text-green-600"
      : trend?.includes("-")
      ? "text-red-500"
      : "text-slate-400";
 
  return (
    <div className="bg-white p-4 rounded-xl border">
      <div className="text-sm text-slate-500">{title}</div>
      <div className="flex justify-between items-end mt-1">
        <div className="text-xl font-semibold">{value}</div>
        <div className={`text-xs font-medium ${color}`}>{trend}</div>
      </div>
    </div>
  );
};
 
const TinyStat = ({ label, value }: any) => (
  <div className="bg-slate-100 p-3 rounded-lg">
    <div className="text-xs text-slate-500">{label}</div>
    <div className="text-lg font-semibold">{value}</div>
  </div>
);
 
const Placeholder = ({ title }: any) => (
  <div className="text-center text-slate-400 mt-20">
    {title} page coming soon
  </div>
);
