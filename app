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
 
  const navItems = [
    { key: "home", label: "Home", icon: Home },
    { key: "ingestion", label: "Automate Ingestion", icon: Settings },
    { key: "extraction", label: "Data Extraction", icon: FlaskConical },
    { key: "assistant", label: "Agentic RAG Assistant", icon: Bot },
    { key: "portal", label: "Customer Product Portal", icon: Package },
    { key: "regulatory", label: "Regulatory Dashboard", icon: Shield },
    { key: "comparison", label: "Smart Comparison", icon: GitCompare },
    { key: "generator", label: "AI Content Generator", icon: FileText },
  ];
 
  return (
    <div className="flex h-screen bg-white text-slate-900">
 
      {/* SIDEBAR */}
      <aside className="w-20 border-r border-slate-200 flex flex-col items-center py-4">
 
        {/* LOGO */}
        <div className="w-12 h-12 mb-6 rounded-lg overflow-hidden border border-slate-200 bg-white flex items-center justify-center">
          <img
            src="/logo.jpg"
            alt="Logo"
            className="max-w-full max-h-full object-contain"
          />
        </div>
 
        {/* NAV ICONS */}
        <div className="flex flex-col gap-4">
          {navItems.map((item) => {
            const Icon = item.icon;
 
            return (
              <div key={item.key} className="group relative">
                <button
                  onClick={() => setCurrentScreen(item.key as Screen)}
                  className={`w-10 h-10 flex items-center justify-center rounded-full
                    transition-colors duration-200
                    ${
                      currentScreen === item.key
                        ? "bg-yellow-300 text-black"
                        : "text-black hover:bg-yellow-200"
                    }`}
                >
                  <Icon size={16} strokeWidth={2.5} />
                </button>
 
                {/* TOOLTIP */}
                <div className="absolute left-16 top-1/2 -translate-y-1/2
                  bg-black text-white text-xs px-3 py-1 rounded-md
                  opacity-0 group-hover:opacity-100 transition whitespace-nowrap">
                  {item.label}
                </div>
              </div>
            );
          })}
        </div>
      </aside>
 
      {/* MAIN */}
      <div className="flex-1 flex flex-col">
 
        {/* EMPTY TOP SPACE */}
        <div className="h-20 bg-transparent" />
 
        {/* CONTENT */}
        <div className="flex-1 overflow-y-auto p-6 bg-slate-50">
          {currentScreen === "home" && <HomeDashboard />}
          {currentScreen === "ingestion" && <AutomateIngestionPage />}
          {currentScreen !== "home" && currentScreen !== "ingestion" && (
            <Placeholder title={currentScreen} />
          )}
        </div>
      </div>
    </div>
  );
}
 
/* ---------------- COMPONENTS ---------------- */
 
const SectionHeader = ({ title, subtitle }: any) => (
  <div>
    <div className="flex items-center gap-3">
      <h2 className="text-2xl font-semibold tracking-tight">
        {title}
      </h2>
 
      {/* DARKER YELLOW BOXES */}
      <div className="flex gap-2">
        <span className="w-4 h-4 rounded-sm bg-yellow-400" />
        <span className="w-4 h-4 rounded-sm bg-yellow-400" />
        <span className="w-4 h-4 rounded-sm bg-yellow-400" />
      </div>
    </div>
 
    {subtitle && (
      <p className="text-sm text-slate-500 mt-2 max-w-2xl">
        {subtitle}
      </p>
    )}
  </div>
);
 
const HomeDashboard = () => {
  return (
    <div className="space-y-6">
      <SectionHeader
        title="Application Features Hub"
        subtitle="Overview of platform activity"
      />
 
      <div className="grid grid-cols-4 gap-4">
        <MetricCard title="Documents" value="324" />
        <MetricCard title="Success Rate" value="97%" />
        <MetricCard title="Answers" value="512" />
        <MetricCard title="Compliance" value="92%" />
      </div>
 
      <div className="grid grid-cols-3 gap-6">
        <Card title="Throughput">
          <div className="h-32 bg-slate-100 rounded-lg" />
        </Card>
 
        <Card title="Distribution">
          <div className="h-32 bg-slate-100 rounded-lg" />
        </Card>
 
        <Card title="Risk Heatmap">
          <div className="h-32 bg-slate-100 rounded-lg" />
        </Card>
      </div>
    </div>
  );
};
 
const AutomateIngestionPage = () => {
  const [name, setName] = useState("");
 
  return (
    <div className="space-y-6">
      <SectionHeader
        title="Automate Ingestion"
        subtitle="Upload and process documents"
      />
 
      <div className="grid grid-cols-3 gap-6">
        <div className="col-span-2 space-y-6">
          <Card title="Upload & Queue">
            <div className="flex gap-3">
              <input
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Enter file name"
                className="flex-1 border border-slate-200 rounded-lg px-3 py-2"
              />
              <button className="bg-yellow-300 hover:bg-yellow-400 px-4 py-2 rounded-lg font-medium">
                Enqueue
              </button>
            </div>
          </Card>
 
          <Card title="Active Queue">
            <div className="text-sm text-slate-500">
              Your queue items will appear here
            </div>
          </Card>
        </div>
 
        <div>
          <Card title="Insights">
            <div className="h-40 bg-slate-100 rounded-lg" />
          </Card>
        </div>
      </div>
    </div>
  );
};
 
const Card = ({ title, children }: any) => (
  <div className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm">
    <h3 className="font-semibold mb-4">{title}</h3>
    {children}
  </div>
);
 
const MetricCard = ({ title, value }: any) => (
  <div className="bg-white border border-slate-200 rounded-xl p-4 shadow-sm">
    <div className="text-sm text-slate-500">{title}</div>
    <div className="text-2xl font-semibold mt-1">{value}</div>
  </div>
);
 
const Placeholder = ({ title }: any) => (
  <div className="flex items-center justify-center h-full text-slate-400">
    {title} page coming soon
  </div>
);
